# NixOS Configuration Project

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
*   `configuration.nix`: The main system-wide configuration file. It imports all the necessary modules from the `modules/` directory.
*   `home.nix`: The main `home-manager` configuration file. It defines user-specific packages, shell settings (aliases, Zsh), Git configuration, and other user-level programs.
*   `hosts/`: This directory contains host-specific configurations. Each subdirectory corresponds to a machine and includes hardware-specific settings.
*   `modules/`: This directory contains a collection of modularized NixOS configurations for different aspects of the system, such as applications, services, and hardware.
*   `config/cosmic/`: This directory holds settings for the Cosmic desktop environment, which are managed outside of the NixOS configuration but are part of the overall setup.

## Development Conventions

*   **Declarative Changes:** All system and user configurations are managed declaratively within `.nix` files. To make changes, you modify these files and then rebuild the system.
*   **Modularity:** New features or configurations should be added as new modules in the `modules/` directory and then imported into `configuration.nix`.
*   **Host-Specific Settings:** Any configuration that is unique to a single machine should be placed in the corresponding file within the `hosts/` directory.
*   **User-Specific Settings:** User-level packages and configurations are managed in `home.nix` using `home-manager`.

## 📝 Notes

- This configuration uses `nvf` for Neovim configuration (Neovim from Scratch).
- The system is set to French locale and timezone.
- All modules are optional and can be enabled/disabled via the options in
  `options.nix`.

## 📄 License

MIT License - see `LICENSE` for details.