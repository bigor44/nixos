# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

NixOS flake (nixos-unstable, flake-parts, home-manager master) for host `grospc`. No import-tree / dendritic auto-import.

## Commands

Enter the dev shell with `nix develop` (installs the pre-commit hook and puts the shortcut commands below on PATH — they only exist inside it).

- `nix fmt` — treefmt (`treefmt.toml`): nixfmt, shfmt, prettier, taplo, stylua
- `qc` = `pre-commit run` — treefmt, statix, deadnix, shellcheck, luacheck, detect-private-keys
- `qf` = `nix flake check` — also runs the pre-commit checks
- Build one host without switching: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- `nrs` / `nrb` = flake check + `sudo nixos-rebuild switch|boot --flake .` — **ask before running these** (or any `nixos-rebuild`); they change the live system. It builds the host matching the current hostname.

No unit tests: validation = `nix fmt` + `qc` + `qf`.

## Gotchas

- Flakes only see git-tracked files: `git add` (or `git add -N`) new files before `nix flake check`/build, otherwise they "don't exist".
- New modules must be listed in `nix/modules.nix` — it's an explicit import list; an unlisted file is silently ignored.
- Home Manager entry is `modules/home/default.nix` (CONTRIBUTING.md wrongly says `home.nix`); user is `bigor`, HM stateVersion follows the system's.
- Neovim config lives in `dotfiles/nvim` (Lua, deployed via HM) — nixvim was removed. Desktop is COSMIC.

## Module conventions

- `modules/nixos/platform/` — always-on, no enable option.
- `modules/nixos/features/<category>/<name>.nix` — optional; must declare `options.bigor.features.<category>.<name>.enable = lib.mkEnableOption ...` and wrap everything in `lib.mkIf cfg.enable`. Hosts enable them under `bigor.features.<category>.<name>.enable` in `hosts/<host>/configuration.nix`.
- Every `.nix` file starts with a two-line header: `# Feature: <name>` / `# Purpose: ...` (use `# Platform:`, `# Host:`, `# Home:`, `# Flake:` as appropriate). Shell scripts: shebang, then `# Script:` / `# Purpose:`.
- `default.nix` only for directories that aggregate several files; `configuration.nix` only in `hosts/*/`. Use descriptive filenames.
- Open firewall ports inside the feature module that defines the service.
- Comments in English, sparse, explaining why — not what.
- Never commit plaintext secrets or keys.

## Git

- Commit directly on `main`, Conventional Commits (`feat(scope): ...`, `fix:`, `chore:`, `refactor:`).
- `qf` must pass before pushing. Update README.md when features are added/removed.
