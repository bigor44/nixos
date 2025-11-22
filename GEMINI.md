# GEMINI.md: Project Overview

This file provides a comprehensive overview of the NixOS configuration project, intended to be used as a context for AI-assisted development.

## Project Overview

This is a NixOS configuration managed using [Nix Flakes](https://nixos.wiki/wiki/Flakes). It defines the system configurations for multiple machines, ensuring reproducibility and modularity. The project is structured to separate machine-specific settings from shared, reusable modules.

The main technologies used are:
- **NixOS**: A declarative Linux distribution.
- **Nix Flakes**: A feature to manage dependencies and package Nix expressions.
- **Home Manager**: To declaratively manage user-specific configurations (`dotfiles`).
- **flake-parts**: To simplify the structure of the `flake.nix` file.

## Project Structure

- **`flake.nix`**: The entry point of the configuration. It defines the project's dependencies (inputs) like `nixpkgs`, `home-manager`, etc., and orchestrates the build for each host (outputs).

- **`hosts/`**: This directory contains the configuration for each individual machine.
  - `grospc/`: Configuration for a desktop machine.
  - `minipc/`: Configuration for a headless server.
  Each host directory has a `default.nix` for its main configuration and a `hardware-configuration.nix` for hardware-specific settings.

- **`modules/`**: This directory contains reusable modules that are shared across different hosts.
  - **`nixos/`**: System-level modules, categorized into:
    - `core/`: Base system settings, users, and custom options.
    - `desktop/`: GUI-related configurations (audio, bluetooth, desktop environment).
    - `services/`: Server-side applications and services.
    - `nixvim/`: Declarative configuration for Neovim.
  - **`home/`**: User-level modules managed by Home Manager, defining packages, shell aliases, and git configuration for the user `bigor`.

## Building and Running the Configuration

To apply the configuration to a specific host, you use the `nixos-rebuild` command with the appropriate flake output.

**1. Apply the configuration:**

- For the desktop machine (`grospc`):
  ```bash
  nixos-rebuild switch --flake .#grospc
  ```

- For the server (`minipc`):
  ```bash
  nixos-rebuild switch --flake .#minipc
  ```

**2. Update Dependencies:**

To update all flake inputs (like `nixpkgs`) to their latest versions, run:
```bash
nix flake update
```
This will update the `flake.lock` file. You can then rebuild the system to apply the updates.

## Development Conventions

- **Modularity**: Configurations are broken down into small, single-purpose files (modules) and imported where needed.
- **Host-specific vs. Shared**: General settings belong in `modules/`, while machine-specific values (like hostname or filesystems) belong in `hosts/`.
- **Custom Options**: The project defines custom NixOS options in `modules/nixos/core/options.nix` to toggle features across the configurations (e.g., `system.role`).
- **Code Formatting**: The codebase is formatted using `alejandra`.
- **Linting**: `statix` and `deadnix` are used to check for errors and unused code.
- **Pre-commit Hooks**: The project uses `pre-commit-hooks.nix` to automatically format and lint files before committing. A development shell with these tools can be entered with `nix develop`.
