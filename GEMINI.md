# NixOS Configuration Project

## Project Overview

This repository contains a complete, declarative NixOS configuration managed using Nix Flakes. It's designed to be reproducible and modular, supporting multiple host machines (`grospc` and `minipc`). The configuration includes system-level settings, user-specific environments via `home-manager`, and detailed customizations for the Cosmic desktop environment.

The core of the project is the modular approach, with different functionalities split into separate files under the `modules/` directory. This makes it easy to manage and toggle features like audio, Bluetooth, various applications, and services.

## Building and Running

To apply the configuration to a NixOS system, you need to have Nix Flakes enabled. The primary command to build and switch to a new configuration is:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Replace `<hostname>` with the target host you want to build for (e.g., `grospc` or `minipc`).

**Common Commands:**

*   **Apply the configuration:** `sudo nixos-rebuild switch --flake .#<hostname>`
*   **Update flake inputs:** `nix flake update`
*   **Check the flake:** `nix flake check`

## Project Structure

*   `flake.nix`: The entry point for the Nix Flake. It defines the project's inputs (like `nixpkgs` and `home-manager`) and outputs the final `nixosConfigurations` for each host.
*   `configuration.nix`: The main system-wide configuration file. It imports NixOS modules from the `modules/nixos/` directory.
*   `home.nix`: The main `home-manager` configuration file. It imports user-specific modules from the `modules/home/` directory.
*   `hosts/`: This directory contains host-specific configurations. Each subdirectory corresponds to a machine and includes hardware-specific settings.
*   `modules/`: This directory contains modularized configurations:
    *   `modules/nixos/`: Contains NixOS modules for system-wide configurations. These include `adguard.nix`, `desktop.nix`, `llm.nix`, `network.nix`, `nfs-client.nix`, `nfs-server.nix`, `nixvim.nix`, `options.nix`, `packages.nix`, `sshd.nix`, `system.nix`, and `users.nix`.
    *   `modules/nixos/nixvim/`: Contains modules for configuring nixvim. These include `keymaps.nix`, `options.nix`, and `plugins.nix`.
    *   `modules/home/`: Contains home-manager modules for user-specific configurations. These include `git.nix`, `packages.nix`, and `shell.nix`.
*   `config/cosmic/`: This directory holds settings for the Cosmic desktop environment, which are managed outside of the NixOS configuration but are part of the overall setup.

## Development Conventions

*   **Declarative Changes:** All system and user configurations are managed declaratively within `.nix` files. To make changes, you modify these files and then rebuild the system.
*   **Modularity:** New features or configurations should be added as new modules in the `modules/nixos` or `modules/home` directories and then imported into `configuration.nix` or `home.nix` respectively.
*   **Host-Specific Settings:** Any configuration that is unique to a single machine should be placed in the corresponding file within the `hosts/` directory.
*   **User-Specific Settings:** User-level packages and configurations are managed in `home.nix` using `home-manager`.
