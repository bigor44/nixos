# Project Overview

This repository contains a fully-declarative NixOS configuration for two machines, `grospc` (a desktop) and `minipc` (a headless server). It uses Nix Flakes to manage dependencies and ensure reproducible builds. The configuration is split into shared modules and host-specific settings.

**Key Technologies:**

*   **NixOS:** A Linux distribution with a declarative configuration model.
*   **Nix Flakes:** A new feature in Nix for managing dependencies and improving reproducibility.
*   **Home Manager:** A tool for managing user-specific configuration (dotfiles).
*   **COSMIC:** A new desktop environment on the `grospc` machine.
*   **pre-commit-hooks-nix:** For managing pre-commit hooks.

**Architecture:**

*   The entry point is `flake.nix`, which defines the inputs (Nixpkgs, Home Manager, etc.) and builds the two NixOS systems.
*   `hosts/`: Contains the host-specific configuration for `grospc` and `minipc`.
*   `modules/`: Contains shared configuration modules for both NixOS and Home Manager.
    *   `nixos/`: System-wide settings, packages, and services.
    *   `home/`: User-specific settings, packages, and dotfiles, managed by Home Manager.

# Building and Running

The primary way to manage the system is through `nixos-rebuild`.

*   **Build and switch to a new generation:**
    ```bash
    # For the desktop
    sudo nixos-rebuild switch --flake .#grospc

    # For the server
    sudo nixos-rebuild switch --flake .#minipc
    ```

*   **Update flake inputs:**
    ```bash
    nix flake update
    ```

*   **Garbage Collection:**
    ```bash
    # Remove old generations
    sudo nix-collect-garbage -d
    ```

# Development Conventions

*   **Modularity:** The configuration is highly modular, with clear separation between system-level and user-level settings, and between shared and host-specific configurations.
*   **Development Environment:** Development-specific tools (e.g., `alejandra`, `statix`, `deadnix`) are defined in the `devShell` within `flake.nix`. They are not included in the base system or home-manager configuration to keep the user environment clean. To use them, enter the development shell with `nix develop`.
*   **Secrets:** Secrets are not managed in this repository and should be placed in `/etc/nixos/secrets.nix`.
*   **Formatting:** The `README.md` suggests the use of `alejandra` for formatting Nix code, although it is not explicitly enforced in the configuration. Pre-commit hooks are set up to enforce formatting and linting.
