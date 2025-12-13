# Project Overview

This is a **NixOS configuration** repository managed with **Flakes** and **snowfall-lib**. It defines the infrastructure as code for the user's personal systems, separating concerns into system-level configurations, shared modules, and user-level environments (Home Manager).

## Architecture

The project follows the [Snowfall Lib](https://github.com/snowfallorg/lib) structure:

- **`flake.nix`**: The entry point. Inputs include `nixpkgs` (branch: `nixos-25.11`), `home-manager`, and `nixvim`.
- **`systems/`**: Defines specific hosts.
  - **`grospc`**: Main Desktop Workstation (Gaming, Dev).
  - **`minipc`**: Server/Homelab node (inferred).
- **`modules/`**: Reusable NixOS modules.
  - **`nixos/core/`**: Base settings (users, locale, custom options API).
  - **`nixos/desktop/`**: GUI stack (COSMIC, Pipewire, Gaming).
  - **`nixos/services/`**: Server services (Caddy, Adguard, NFS, etc.).
- **`checks/`**: Custom checks (e.g., `nix-lint`).
- **`homes/`**: Home Manager configurations.
  - **`bigor`**: Main user profile.
- **`packages/`**: Custom packages (e.g., `turtle-wow`).

## Custom Namespace: `bigor`

Configuration is abstracted via a custom option namespace defined in `modules/nixos/core/options.nix`. Key flags include:

- `bigor.roles.desktop`: Enables full GUI, Audio, and Font stack.
- `bigor.roles.homelab_master`: Enables server-grade tooling.
- `bigor.services.nfs.{server,client}`: Manages NFS shares.
- `bigor.network.mainInterface`: Defines primary NIC.

# Building and Running

Since this is a Flake-based setup, standard Nix commands apply.

## Applying System Configuration

To switch the current system to the configuration defined for its hostname:

```bash
# Apply configuration for the current hostname
sudo nixos-rebuild switch --flake .

# Apply configuration for a specific host (e.g., grospc)
sudo nixos-rebuild switch --flake .#grospc
```

## Updating Dependencies

```bash
# Update all inputs (nixpkgs, home-manager, etc.)
nix flake update
```

# Development Conventions

- **Formatting**: The project uses `treefmt`.
- **Linting**: Custom checks (using `statix` and `deadnix`) are defined in `checks/`.
- **Secrets**: No explicit secret management (like sops-nix) was observed in the initial scan, but check `modules/nixos/services/tailscale.nix` or others for key paths.
- **Modularity**: Prefer creating feature flags in `modules/nixos/core/options.nix` rather than hardcoding imports in system configurations.
- **Kernel**: `grospc` uses the Zen kernel (`pkgs.linuxPackages_zen`) and `amd_pstate` for performance.

# Key Files

- `flake.nix`: Dependency definitions and output schema.
- `modules/nixos/core/options.nix`: The schema for the `bigor` configuration namespace.
- `systems/x86_64-linux/grospc/default.nix`: Example of a host configuration using the custom options.
- `homes/x86_64-linux/bigor/default.nix`: Entry point for user-specific dotfiles and packages.
