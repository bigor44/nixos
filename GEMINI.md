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

- **Examples:** `boot.nix`, `network.nix`, `users.nix`, `policies/`.
- **Convention:** These modules do **not** have `enable` options.

### 3. Feature Modules (`modules/nixos/features/`)

**Optional** capabilities that must be explicitly enabled per host.

- **Examples:** `gaming.nix`, `desktop.nix`, `audio.nix`.
- **Convention:**
  - Must define an `enable` option (e.g., `bigor.features.gaming.enable`).
  - Configuration must be wrapped in `mkIf cfg.enable`.
  - **Firewall:** Never use `networking.firewall` directly. Use `bigor.platform.firewall.openPorts`.

## Development Workflow

### Environment

Enter the development shell to access tools like `nixos-rebuild`, `sops`, `statix`, and custom scripts.

```bash
nix develop
```

### Build & Deploy

- **Rebuild & Switch:** `nrs` (alias for `sudo nixos-rebuild switch --flake .`)
- **Rebuild & Boot:** `nrb` (alias for `sudo nixos-rebuild boot --flake .`)

### Verification

- **Quick Check:** `check-quick` (or `qc`) - Incremental validation.
- **Full Check:** `check-full` (or `qf`) - Validates all hosts.
- **Intelligent Check:** `check-mega` (or `mega`) - Auto-selects check based on git state.
- **DNS Test:** `dns-test` - Verify DNS settings.

## Coding Standards

### File Headers

Every Nix file requires a specific 2-line header:

```nix
# Category: <name>
# Purpose: <Description of why this file exists>
```

Categories: `# Feature:`, `# Home:`, `# Host:`, `# Policy:`.

### Nix Language Rules

- **Inherit Pattern:** Only `inherit (lib)` if using **3 or more** functions. Otherwise, use `lib.mkIf`, etc.
- **Comments:** Explain _why_, not _what_. Use English.

### Secrets

Managed via **sops-nix** with **age**.

- **File:** `secrets/secrets.yaml`
- **Edit:** `sops secrets/secrets.yaml`

## Key Commands (Aliases)

- `nrs`: Rebuild system (switch)
- `nrb`: Rebuild system (boot)
- `gcn`: Git Commit Nix (Format -> Stage -> Check -> Commit)
