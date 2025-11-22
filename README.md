# NixOS Configuration

This repository contains a NixOS configuration managed with flakes. It defines the configurations for multiple hosts and uses home-manager to manage user-specific settings.

## Project Overview

The project is structured to manage NixOS configurations for different machines from a single repository. It leverages flakes for reproducibility and modularity.

- **Hosts:**
  - `grospc`: A desktop machine.
  - `minipc`: A server.
- **Key Technologies:**
  - **NixOS:** The operating system.
  - **Flakes:** Used for managing dependencies and providing reproducible builds.
  - **Home Manager:** Manages user-specific configurations (dotfiles, packages, etc.).
  - **NixVim:** Manages the Neovim configuration.

## Building and Running

To apply the configuration to a specific host, use the following command from the root of the repository:

```bash
nixos-rebuild switch --flake .#<hostname>
```

Replace `<hostname>` with the name of the host you want to configure (e.g., `grospc` or `minipc`).

For example, to apply the configuration to `grospc`:

```bash
nixos-rebuild switch --flake .#grospc
```

## Development Conventions

The configuration is organized into modules to promote reusability and maintainability.

- **`flake.nix`:** The entry point of the configuration. It defines the inputs (dependencies) and outputs (NixOS configurations, dev shells, etc.).
- **`hosts/`:** Contains host-specific configurations. Each subdirectory corresponds to a different machine.
- **`modules/nixos/`:** Contains system-wide configurations that are shared across hosts. This is further divided into subdirectories for different aspects of the system (e.g., `core`, `desktop`, `services`).
- **`modules/home/`:** Contains the home-manager configuration for the user, which is also shared across hosts.

This modular approach allows for a clean separation of concerns and makes it easy to manage configurations for multiple machines.
