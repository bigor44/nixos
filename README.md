# NixOS Configuration

This repository contains my personal NixOS configuration, managed declaratively using Nix Flakes. It includes system-wide and user-specific settings, as well as configurations for the Cosmic desktop environment.

## Features

-   **Declarative & Reproducible:** The entire system is configured declaratively, ensuring a consistent and reproducible setup.
-   **Multi-Host Support:** Easily manage configurations for multiple machines (`grospc`, `minipc`) from a single codebase.
-   **Modular Design:** The configuration is broken down into logical modules (e.g., `audio.nix`, `bluetooth.nix`, `desktop-apps.nix`), making it easy to understand, customize, and maintain.
-   **Home Manager Integration:** User-specific configurations (dotfiles, packages, services) are managed through Home Manager, keeping the user environment clean and portable.
-   **Custom Desktop Environment:** Includes detailed theming and settings for the Cosmic desktop environment.
-   **Development Environment:** Pre-configured with essential development tools like Neovim, Git, Zsh (with Oh My Zsh), and various shell aliases.
-   **Services:** Includes configurations for services like AdGuard, SSH, Podman (with Home Assistant), and Ollama.

## Structure

| Path | Description |
| :--- | :--- |
| `flake.nix` | The entry point for the Nix Flake. It defines the project's inputs (like `nixpkgs` and `home-manager`) and outputs the final `nixosConfigurations` for each host. |
| `configuration.nix` | The main system-wide configuration file. It imports all the necessary modules from the `modules/` directory. |
| `home.nix` | The main `home-manager` configuration file. It defines user-specific packages, shell settings (aliases, Zsh), Git configuration, and other user-level programs. |
| `hosts/` | This directory contains host-specific configurations. Each subdirectory corresponds to a machine and includes hardware-specific settings. |
| `modules/` | This directory contains a collection of modularized NixOS configurations for different aspects of the system, such as applications, services, and hardware. |
| `config/cosmic/` | This directory holds settings for the Cosmic desktop environment, which are managed outside of the NixOS configuration but are part of the overall setup. |

## Usage

### Prerequisites

-   A running NixOS system.
-   Nix Flakes enabled on your system.

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/bigor44/nixos.git
    cd nixos
    ```

2.  Apply the configuration for a specific host (e.g., `grospc`):
    ```bash
    sudo nixos-rebuild switch --flake .#grospc
    ```

### Customization

To adapt this configuration for your own use, you would typically:

1.  **Add a new host:** Create a new directory under `hosts/` for your machine.
2.  **Create a hardware configuration:** Generate a `hardware-configuration.nix` file for your new host.
3.  **Define the host:** Add a new output to `flake.nix` for your new host, pointing to your new host's configuration files.
4.  **Customize modules:** Enable, disable, or modify the modules imported in `configuration.nix` to fit your needs.
5.  **Customize user settings:** Modify `home.nix` to configure your user environment.

## License

This project is licensed under the [MIT License](LICENSE).
