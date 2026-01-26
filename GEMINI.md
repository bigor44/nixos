# Gemini Context: Bigor's NixOS Configuration

## Project Overview

This is a modular **NixOS configuration** repository using **Nix Flakes**. It manages the system configuration for multiple hosts, employing a structured approach with platform (mandatory) and feature (optional) modules. It also integrates **Home Manager** for user environments and **SOPS** for secret management.

## Architecture

### Directory Structure

- `flake.nix`: The main entry point, defining inputs and outputs.
- `nix/`: Core Flake logic.
  - `hosts.nix`: Defines the available NixOS configurations (`nixosConfigurations`).
  - `devshell.nix`: Defines the development shell and aliases.
  - `modules.nix`: Aggregates module imports.
- `hosts/`: Contains host-specific configurations.
  - `grospc/`, `minipc/`, `minidesk/`: Subdirectories for each machine.
  - Each host directory has a `configuration.nix` which is the entry point for that host.
- `modules/`: Reusable Nix modules.
  - `nixos/platform/`: **Mandatory** base infrastructure (boot, network, users, etc.). These are always active.
  - `nixos/features/`: **Optional** capabilities (gaming, dev tools, monitoring, etc.). These must be explicitly enabled via `bigor.features.<category>.<name>.enable`.
  - `home/`: Home Manager modules for user-specific dotfiles and apps.
- `secrets/`: Encrypted secrets managed by SOPS (`secrets.yaml`).
- `certs/`: Certificates.
- `dotfiles/`: Raw configuration files for applications.
- `scripts/`: Utility scripts.

### Defined Hosts

- `grospc`
- `minipc`
- `minidesk`

## Development Workflow

This project uses a custom development shell to enforce quality and safety.

### Setup

Enter the development environment:

```bash
nix develop
```

This environment provides necessary tools (`nixos-rebuild`, `sops`, `treefmt`, etc.) and useful aliases.

### Key Aliases & Commands

| Alias     | Command                                                  | Description                                                   |
| :-------- | :------------------------------------------------------- | :------------------------------------------------------------ |
| `qc`      | `pre-commit run`                                         | **Quick Check**: fast formatting and linting of staged files. |
| `qf`      | `nix flake check`                                        | **Full Check**: complete validation of all hosts and builds.  |
| `gcn`     | `git add . && pre-commit run && git commit`              | **Safe Commit**: stages, checks, and commits changes.         |
| `gps`     | `nix flake check && git push`                            | **Safe Push**: runs full check before pushing.                |
| `nrs`     | `nix flake check && sudo nixos-rebuild switch --flake .` | **Rebuild Switch**: checks and applies config immediately.    |
| `nrb`     | `nix flake check && sudo nixos-rebuild boot --flake .`   | **Rebuild Boot**: checks and applies config on next boot.     |
| `nix fmt` | `treefmt`                                                | Formats all files in the project.                             |

### Secrets Management

- **Tool:** SOPS with age.
- **File:** `secrets/secrets.yaml`.
- **Edit:** `sops secrets/secrets.yaml`.
- **Usage:** Secrets are referenced in modules via `config.sops.secrets`. Do **not** commit plain-text secrets.

## Coding Conventions

- **Headers:** All Nix files should start with a header indicating their category and purpose:
  ```nix
  # Feature: audio
  # Purpose: PipeWire audio stack...
  ```
- **Feature Modules (`modules/nixos/features/`):**
  - Must define an `enable` option (`bigor.features.<category>.<name>.enable`).
  - Configuration must be wrapped in `mkIf cfg.enable`.
- **Platform Modules (`modules/nixos/platform/`):**
  - Do NOT have `enable` options.
  - Are always imported and active.
- **Naming:**
  - `configuration.nix` is reserved for host entry points.
  - Avoid `default.nix` for single-file imports.
  - Use descriptive names (e.g., `gaming.nix` instead of `default.nix`).
- **Comments:** Focus on _why_, not _what_.

## Contribution

- Create a branch for features: `git checkout -b feature/name`.
- Run `qc` before committing.
- Run `qf` before pushing or requesting a review.
