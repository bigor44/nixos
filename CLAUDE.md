# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

NixOS flake (nixos-unstable, flake-parts, home-manager master, nixvim) for the single host `grospc`. Flat layout: no option layer, no auto-import.

## Commands

No devshell and no git hook: formatters and linters (`nix/checks.nix`) run through `nix fmt` and `nix flake check`. The shortcuts below are system-wide fish abbreviations (`modules/nixos/shell.nix`), available in any interactive fish.

- `nix fmt` — nixfmt, taplo, prettier, statix, deadnix, shellcheck, detect-private-keys on all files (or only the files given), applying fixes
- `qf` = `nix flake check` — also checks formatting and lint (read-only)
- Build without switching: `nix build .#nixosConfigurations.grospc.config.system.build.toplevel`
- `nrs` / `nrb` = flake check + `nh os switch|boot` — **ask before running these** (or any `nixos-rebuild` / `nh os`); they change the live system.

No unit tests: validation = `nix fmt` (applies fixes) + `qf` (fails on unformatted or lint errors).

## Gotchas

- Flakes only see git-tracked files: `git add` (or `git add -N`) new files before `nix flake check`/build, otherwise they "don't exist".
- New system modules must be added to `imports` in `hosts/grospc/configuration.nix`; an unlisted file is silently ignored.
- Home Manager entry is `modules/home/default.nix`; user is `bigor`, HM stateVersion follows the system's.
- Neovim is built by nixvim in `modules/nixos/nixvim.nix` (NixOS module, config baked into the wrapper; `~/.config/nvim` is unused). nixd reads options from `/home/bigor/nixos` via `builtins.getFlake`. Desktop is COSMIC.
- `dotfiles/` is an out-of-store symlink: deleting a file there deletes it from `~/.config` immediately. Exception: `autostart/` is copied read-only into the store (Discord rewrites its entry), so changes there need a rebuild. The generated COSMIC theme dirs are git-ignored, not removed.

## Module conventions

- `modules/nixos/<topic>.nix` — plain NixOS modules, no `enable` options or `mkIf` wrappers; group by topic (desktop, gaming, dev…) rather than one file per service.
- `modules/home/<topic>.nix` — Home Manager modules, imported from `modules/home/default.nix`; only user-specific config (identity, dotfiles). Packages, shell setup, aliases and abbreviations go in NixOS modules.
- Every `.nix` file starts with a two-line header: `# Platform: <name>` / `# Purpose: ...` (use `# Host:`, `# Home:`, `# Flake:` as appropriate). Shell scripts: shebang, then `# Script:` / `# Purpose:`.
- `default.nix` only for directories that aggregate several files; `configuration.nix` only in `hosts/*/`. Use descriptive filenames.
- Open firewall ports in the module that defines the service.
- Comments in English, sparse, explaining why — not what.
- Never commit plaintext secrets or keys.

## Git

- Commit directly on `main`, Conventional Commits (`feat(scope): ...`, `fix:`, `chore:`, `refactor:`).
- `qf` must pass before pushing. Update README.md when modules are added/removed.
