# Bigor's NixOS Configuration

## Project Overview

This repository contains the NixOS configuration for Bigor's infrastructure, managed using **Nix Flakes**. It supports multiple hosts (workstations, servers) through a modular architecture separating core platform requirements and specific features.

## Architecture

The project is structured to maximize code reuse and clarity:

- **`flake.nix`**: The entry point defining inputs, outputs, and system configurations.
- **`hosts/`**: Configurations for specific machines (e.g., `grospc`, `minipc`). Each host has a `configuration.nix` entry point.
- **`modules/`**:
  - **`nixos/platform/`**: Mandatory infrastructure modules (networking, users, core system). Always active.
  - **`nixos/features/`**: Optional capabilities (e.g., `gaming`, `audio`, `dev-tools`) enabled via `bigor.features.<category>.<name>.enable`.
  - **`home/`**: Home Manager modules for user-specific configuration.
- **`nix/`**: Flake helper files, checks, and the development shell definition.
- **`secrets/`**: Encrypted secrets managed by **SOPS**.
- **`dotfiles/`**: Application configuration files (Cosmic DE, autostart entries).

## Development Environment

The project includes a comprehensive development shell defined in `nix/devshell.nix`.

**Enter the shell:**

```bash
nix develop
```

### Key Tools & Aliases

The shell provides several aliases to streamline the workflow:

| Alias | Command                                            | Description                                                                    |
| :---- | :------------------------------------------------- | :----------------------------------------------------------------------------- |
| `qc`  | `pre-commit run`                                   | **Quick Check**: Runs formatting and linting on staged files.                  |
| `qf`  | `nix flake check`                                  | **Full Check**: Validates the entire flake, including all host configurations. |
| `gcn` | _(sequence)_                                       | **Safe Commit**: Stages all changes, runs checks, and commits.                 |
| `gps` | _(sequence)_                                       | **Safe Push**: Runs full checks and pushes to remote.                          |
| `nrs` | `nix flake check && sudo nixos-rebuild switch ...` | **Rebuild Switch**: Deploys changes to the current host safely.                |
| `nrb` | `nix flake check && sudo nixos-rebuild boot ...`   | **Rebuild Boot**: Builds changes for the next boot safely.                     |

### Included Tools

- **Formatters:** `treefmt`, `nixfmt`, `shfmt`, `prettier`, `taplo`.
- **Linters:** `statix`, `deadnix`, `shellcheck`.
- **Secrets:** `sops`, `age`.

## Conventions & Guidelines

Refer to `CONTRIBUTING.md` for detailed rules. Key takeaways:

### 1. File Headers

Every Nix file must start with a descriptive 2-line header:

```nix
# <Category>: <Name>
# Purpose: <Brief description>
```

Categories: `Platform`, `Feature`, `Home`, `Host`.

### 2. Module System

- **Platform Modules:** No `enable` option. Always active.
- **Feature Modules:** MUST have an `enable` option (`bigor.features...`). Default to `false`.

### 3. Secrets

- **NEVER** commit plain-text secrets.
- Use `sops secrets/secrets.yaml` to edit.
- Reference via `config.sops.secrets`.

### 4. Commits

- Use `gcn` to ensure quality.
- Follow the format: `type: message`.

## Usage

### Adding a New Feature

1.  Create the file in `modules/nixos/features/<category>/<name>.nix`.
2.  Add the standard header.
3.  Define the `enable` option.
4.  Import it in `modules/nixos/features/default.nix` (or category default).

### Deploying to a Host

To deploy to the current machine (assuming it matches a host definition):

```bash
nrs
```

To deploy to a specific remote host:

```bash
nixos-rebuild switch --flake .#<hostname> --target-host <user>@<ip>
```
