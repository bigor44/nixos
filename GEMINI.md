# GEMINI.md: Project Overview

This file provides a comprehensive overview of the NixOS configuration project, intended to be used as a context for AI-assisted development.

## Project Overview

This is a NixOS configuration managed using [Nix Flakes](https://nixos.wiki/wiki/Flakes). It defines the system configurations for multiple machines, ensuring reproducibility and modularity. The project is structured to separate machine-specific settings from shared, reusable modules.

The main technologies used are:
- **NixOS**: A declarative Linux distribution.
- **Nix Flakes**: A feature to manage dependencies and package Nix expressions.
- **Home Manager**: To declaratively manage user-specific configurations (`dotfiles`).
- **flake-parts**: To simplify the structure of the `flake.nix` file.
- **sops-nix**: For managing secrets securely.
- **nixvim**: For a declarative Neovim configuration.

## Project Structure

- **`flake.nix`**: The entry point of the configuration. It defines the project's dependencies (inputs) and orchestrates the build for each host.

- **`hosts/`**: Contains the configuration for each individual machine. Each host's `default.nix` sets the machine-specific settings, such as hostname, and assigns a `system.role` (e.g., "desktop" or "server").
  - `grospc/`: Configuration for a desktop machine.
  - `minipc/`: Configuration for a headless server.

- **`modules/`**: Contains reusable modules that are shared across different hosts.
  - **`nixos/`**: System-level modules, categorized into:
    - `core/`: Base system settings, users, custom NixOS options, and sops configuration.
    - `roles/`: Defines machine profiles (`desktop`, `server`, `hybrid`). The configuration for each role is enabled based on the `system.role` option set in a host's configuration.
    - `desktop/`: GUI-related configurations (e.g., Cosmic DE, audio, bluetooth).
    - `services/`: Server-side applications and services. This includes modules for AdGuard Home, Caddy, Tailscale, Vaultwarden, NFS, and monitoring services.
    - `nixvim/`: Declarative configuration for Neovim, including plugins and keymaps.
  - **`home/`**: User-level modules managed by Home Manager for the `bigor` user, defining packages, shell aliases, and git configuration.

- **`secrets/`**: Contains encrypted secret files managed by `sops`.

## Key Architectural Concepts

### Roles

The configuration uses a role-based architecture to tailor systems. The `system.role` option in a host's configuration determines its profile. The available roles are defined in `modules/nixos/roles/`:
- **`desktop`**: Configures a full desktop environment with GUI applications.
- **`server`**: Configures a headless system with various services.
- **`hybrid`**: A combination of both desktop and server roles.

### Custom Options

The project defines many custom NixOS options in `modules/nixos/core/options.nix`. These act as toggles for enabling or disabling features across the configurations (e.g., `sshd.enable`, `adblocker.enable`). This makes it easy to manage which services and features are active on each host.

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

To update all flake inputs to their latest versions, run:
```bash
nix flake update
```
This will update the `flake.lock` file. You can then rebuild the system to apply the updates.

## Development Conventions

- **Modularity**: Configurations are broken down into small, single-purpose modules.
- **Host-specific vs. Shared**: General settings belong in `modules/`, while machine-specific values (like hostname or `system.role`) belong in `hosts/`.
- **Code Formatting**: The codebase is formatted using `alejandra`.
- **Linting**: `statix` and `deadnix` are used to check for errors and unused code.
- **Pre-commit Hooks**: The project uses `pre-commit-hooks.nix` to automatically format and lint files before committing. A development shell with these tools can be entered with `nix develop`.