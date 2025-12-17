# Gemini Project Overview: Bigor's NixOS Configuration

This file provides a comprehensive overview of the NixOS configuration in this repository, intended to be used as a context for AI-driven development and analysis.

## Project Overview

This is a highly modular and opinionated NixOS configuration managed by Nix Flakes. It uses `snowfall-lib` to provide a clean, scalable, and discoverable structure for managing multiple systems (hosts) and user environments (homes).

The primary goal is to maintain a reproducible and declarative environment for both desktop workstations and headless homelab servers from a single codebase.

### Core Technologies

*   **NixOS**: The declarative Linux distribution.
*   **Nix Flakes**: Manages dependencies and provides reproducible builds.
*   **snowfall-lib**: A library that simplifies and structures Nix flakes by auto-discovering systems, homes, and modules.
*   **Home Manager**: Manages user-specific configurations, dotfiles, and packages.
*   **sops-nix**: Manages secrets declaratively and securely.
*   **nixvim**: A fully declarative Neovim setup managed within Nix.

### Architectural Principles

*   **Modularity**: Configuration is broken down into small, reusable modules for NixOS and Home Manager.
*   **Role-Based Abstraction**: High-level roles (e.g., `desktop`, `homelab_master`) are used to compose systems by enabling collections of fine-grained modules.
*   **Host-Specific Overrides**: Each host (system) has its own entry point where it can enable roles and apply specific settings (e.g., hardware configuration, network interfaces).
*   **User Profiles**: Home Manager configurations are also host-aware, allowing a user's environment to differ between machines (e.g., having GUI applications on a desktop but not on a server).

## Repository Structure

*   `flake.nix`: The main entry point. It defines all dependencies and uses `snowfall-lib`'s `mkFlake` function to build all outputs.
*   `systems/`: Contains the entry points for each NixOS system configuration, named by hostname (e.g., `grospc`, `minipc`). This is where roles are enabled and hardware is configured.
*   `homes/`: Contains the entry points for Home Manager configurations. These are structured as `user@host` or as a generic `user` profile that can be imported by host-specific ones.
*   `modules/`:
    *   `nixos/`: Contains all NixOS modules, organized by function (e.g., `services`, `desktop`, `roles`).
    *   `home/`: Contains all Home Manager modules (e.g., `git`, `shell`, `nixvim`).
*   `secrets/`: Contains sops-encrypted secret files.

## Building and Running

The primary way to interact with this configuration is through the `nixos-rebuild` command.

**To build and switch to a new generation for a specific host:**

```bash
# Replace <hostname> with the actual hostname (e.g., grospc)
sudo nixos-rebuild switch --flake .#<hostname>
```

**To build a Home Manager configuration:**

```bash
# Replace <user>@<hostname> with the target (e.g., bigor@grospc)
home-manager switch --flake .#<user>@<hostname>
```

**To run automated checks (linting, etc.):**

```bash
nix flake check
```

## Development Conventions

*   **Modularity**: When adding new functionality, prefer creating a new module in the appropriate `modules/` subdirectory.
*   **Options**: Expose configuration through NixOS options within a `bigor` namespace (e.g., `bigor.services.my-service.enable`).
*   **Roles**: For larger features, consider adding them to one of the existing roles in `modules/nixos/roles/default.nix`.
*   **Secrets**: All secrets must be encrypted with `sops` and added to the `secrets/` directory. Never commit plaintext secrets.
*   **Formatting**: Code is automatically formatted using `treefmt`, which is configured in `treefmt.toml`.
