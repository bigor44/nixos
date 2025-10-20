# NixOS Configuration

This repository contains my personal NixOS configuration, managed declaratively using Nix and NixOS. It includes system-wide and user-specific settings, as well as configurations for the Cosmic desktop environment.

---

## Features

- **Declarative System Configuration:** Everything is defined in Nix expressions for reproducibility.
- **Multi-Host Support:** Configurations for multiple machines (`grospc`, `minipc`).
- **Cosmic Desktop Environment:** Custom settings for Cosmic (System76's desktop environment).
- **Home Manager Integration:** User-specific configurations for tools like Neovim, VSCode, Zsh, and Git.
- **Modular Design:** Easy to enable/disable modules and services.

---

## Structure


| Path                     | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `configuration.nix`       | Main system configuration entry point.                                     |
| `flake.nix`              | Flake definition for reproducible builds.                                  |
| `flake.lock`             | Lockfile for flake inputs.                                                  |
| `home.nix`               | Home Manager configuration.                                                 |
| `home/`                  | User-specific configurations (Neovim, VSCode, Zsh, Git).                  |
| `hosts/`                 | Host-specific configurations and hardware profiles.                        |
| `modules/`               | Reusable NixOS modules (audio, bluetooth, desktop apps, etc.).             |
| `modules-disabled/`      | Disabled modules (e.g., Home Assistant, Podman).                            |
| `config/cosmic/`         | Cosmic desktop environment settings (themes, panels, applets, etc.).       |

---

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/bigor44/nixos.git
cd nixos
```

### 2. Apply the Configuration

For a specific host (e.g., `grospc`):

```bash
sudo nixos-rebuild switch --flake .#grospc
```


## License

This project is licensed under the [MIT License](LICENSE).
