# Gemini Context: Bigor's NixOS Configuration

## Project Overview

This repository contains the NixOS configuration for Bigor's infrastructure. It utilizes **Nix Flakes** for reproducibility and manages multiple hosts (e.g., `grospc`, `minidesk`, `minipc`). The project is structured to separate mandatory infrastructure from optional features.

## Architecture

The configuration is modular, dividing logic into **Platform** and **Features**:

### 1. Hosts (`hosts/`)

Contains entry points for each physical machine.

- **Path:** `hosts/<hostname>/default.nix`
- **Role:** Imports the platform and specific features required for that machine.

### 2. Platform Modules (`modules/nixos/platform/`)

**Mandatory** infrastructure configurations that are always active.

- **Examples:** `boot.nix`, `network/`, `users.nix`, `policies/`.
- **Convention:** These modules do **not** have `enable` options.

### 3. Feature Modules (`modules/nixos/features/`)

**Optional** capabilities that must be explicitly enabled per host.

- **Examples:** `graphics/gaming.nix`, `graphics/desktop.nix`, `hardware/audio.nix`.
- **Convention:**
  - Must define an `enable` option (e.g., `bigor.features.graphics.gaming.enable`).
  - Configuration must be wrapped in `mkIf cfg.enable`.
  - **Firewall:** Never use `networking.firewall` directly. Use `bigor.network.firewall.ports`.

### 4. Home Modules (`modules/home/`)

**User-specific** configurations managed by **Home Manager**.

- **Path:** `modules/home/`
- **Role:** Manages user dotfiles, packages, and services (e.g., Git, Zsh, desktop apps).
- **Integration:** Integrated via `modules/nixos/platform/home.nix`.

## Development Workflow

### Environment

Enter the development shell to access tools like `nixos-rebuild`, `sops`, `statix`, and custom scripts.

```bash
nix develop
```

### Build & Deploy

- **Rebuild & Switch:** `nrs` (alias for `nix flake check && sudo nixos-rebuild switch --flake .`)
- **Rebuild & Boot:** `nrb` (alias for `nix flake check && sudo nixos-rebuild boot --flake .`)

### Verification

- **Quick Check:** `qc` - Fast validation using `pre-commit` (formatting, linting).
- **Full Check:** `qf` - Full system validation using `nix flake check`.
- **DNS Test:** `dns-test` - Verify DNS settings.

## Coding Standards

### File Headers

Every Nix file requires a specific 2-line header:

```nix
# Category: <name>
# Purpose: <Description of why this file exists>
```

Categories: `# Feature:`, `# Host:`, `# Policy:`, `# Home:`, `# Platform:`.

### Nix Language Rules

- **Comments:** Explain _why_, not _what_. Use English.

### Secrets

Managed via **sops-nix** with **age**.

- **File:** `secrets/secrets.yaml`
- **Edit:** `sops secrets/secrets.yaml`

## Key Commands (Aliases)

- `nrs`: Rebuild system (switch) - **Runs full check first**.
- `nrb`: Rebuild system (boot) - **Runs full check first**.
- `gcn`: Git Commit Nix (Stage -> Pre-commit Check -> Commit)
