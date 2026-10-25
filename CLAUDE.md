# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

NixOS flake (nixos-unstable, flake-parts, home-manager master) for the single host `grospc`. Flat layout: no option layer, no auto-import.

## Commands

`nix develop` installs the pre-commit hook and puts the QA tools on PATH. The shortcuts below are zsh aliases from Home Manager (`modules/home/shell.nix`), available in any interactive zsh.

- `nix fmt` — treefmt (`treefmt.toml`): nixfmt, shfmt, prettier, taplo, stylua; works outside the devshell
- `qc` = `nix develop --command pre-commit run` — treefmt, statix, deadnix, shellcheck, luacheck, detect-private-keys
- `qf` = `nix flake check` — also runs the pre-commit checks
- Build without switching: `nix build .#nixosConfigurations.grospc.config.system.build.toplevel`
- `nrs` / `nrb` = flake check + `nh os switch|boot` — **ask before running these** (or any `nixos-rebuild` / `nh os`); they change the live system.

No unit tests: validation = `nix fmt` + `qc` + `qf`.

## Gotchas

- Flakes only see git-tracked files: `git add` (or `git add -N`) new files before `nix flake check`/build, otherwise they "don't exist".
- New system modules must be added to `imports` in `hosts/grospc/configuration.nix`; an unlisted file is silently ignored.
- Home Manager entry is `modules/home/default.nix`; user is `bigor`, HM stateVersion follows the system's.
- Neovim config lives in `dotfiles/nvim` (Lua, symlinked via HM) — nixvim was removed. Desktop is COSMIC.
- `dotfiles/` is an out-of-store symlink: deleting a file there deletes it from `~/.config` immediately. The generated COSMIC theme dirs are git-ignored, not removed.

## Module conventions

- `modules/nixos/<topic>.nix` — plain NixOS modules, no `enable` options or `mkIf` wrappers; group by topic (desktop, gaming, dev…) rather than one file per service.
- `modules/home/<topic>.nix` — Home Manager modules, imported from `modules/home/default.nix`.
- Every `.nix` file starts with a two-line header: `# Platform: <name>` / `# Purpose: ...` (use `# Host:`, `# Home:`, `# Flake:` as appropriate). Shell scripts: shebang, then `# Script:` / `# Purpose:`.
- `default.nix` only for directories that aggregate several files; `configuration.nix` only in `hosts/*/`. Use descriptive filenames.
- Open firewall ports in the module that defines the service.
- Comments in English, sparse, explaining why — not what.
- Never commit plaintext secrets or keys.

## Git

- Commit directly on `main`, Conventional Commits (`feat(scope): ...`, `fix:`, `chore:`, `refactor:`).
- `qf` must pass before pushing. Update README.md when modules are added/removed.
