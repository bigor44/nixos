# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

```bash
# Build or switch a system configuration
sudo nixos-rebuild switch --flake .#<hostname>   # e.g., .#grospc or .#minipc

# Check the flake (runs statix + deadnix linters)
nix flake check

# Format all files
nix fmt
```

## Architecture Overview

This is a NixOS + Home Manager configuration using **snowfall-lib** for an opinionated flake structure. The namespace for all custom options is `bigor.*`.

### Directory Structure

- `systems/x86_64-linux/<hostname>/` - Host-specific NixOS configurations
- `homes/x86_64-linux/<user>[@<host>]/` - Home Manager configurations (host-specific overrides use `user@host` format)
- `modules/nixos/` - NixOS modules (features, profiles, services)
- `modules/home/` - Home Manager modules (shell, git, nixvim, GUI, CLI)
- `checks/` - CI-style checks (statix, deadnix)
- `packages/` - Custom package definitions

### Configuration Hierarchy

**Profiles** (`bigor.profiles.*`) are high-level toggles that enable sets of features:
- `bigor.profiles.workstation` - Desktop: COSMIC DE, audio, fonts, gaming, node-exporter
- `bigor.profiles.homelab-master` - Server: SSH, Tailscale, AdGuard, Caddy, monitoring stack (Prometheus/Grafana/Alertmanager), Ollama, NFS

**Features** (`bigor.features.*`) are individual system capabilities toggled by profiles or directly.

**Services** (`bigor.services.*`) are declarative service modules (adguard, caddy, monitoring/*, nfs, ollama, sshd, tailscale).

### Home Manager

Home modules are enabled via `bigor.home.*`:
- `bigor.home.shell` - Zsh, starship, aliases
- `bigor.home.git` - Git configuration
- `bigor.home.cli-packages` - CLI tools
- `bigor.home.nixvim` - Full Neovim configuration (LSP, treesitter, completion)
- `bigor.home.features.gui` - GUI applications

### Hosts

- **grospc** - Desktop workstation (Zen kernel, gaming-optimized)
- **minipc** - Homelab server (standard kernel, runs all services)

## Key Patterns

- All custom options use the `bigor.*` namespace
- Modules use `mkEnableOption` and `mkDefault` for composability
- Profiles set defaults that can be overridden per-host
- Home Manager configs support host-specific overrides via `user@host` directories
- Secrets are managed with sops-nix (encrypted with age)
