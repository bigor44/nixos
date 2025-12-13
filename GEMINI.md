# Bigor's NixOS Configuration

## Project Overview

This repository contains the Infrastructure as Code (IaC) configuration for my personal infrastructure, built using **NixOS** and **Home Manager**. It leverages **Snowfall Lib** to structure the flake, providing an opinionated and organized file hierarchy.

### Core Technologies

- **NixOS:** Declarative system configuration.
- **Home Manager:** User environment management.
- **Snowfall Lib:** Directory structure and convenience wrappers for Flakes.
- **Nixvim:** Neovim configuration via Nix modules.

## Architecture

The project follows the [Snowfall Lib structure](https://github.com/snowfallorg/lib):

| Directory   | Purpose                                                                 |
| :---------- | :---------------------------------------------------------------------- |
| `systems/`  | Host-specific configurations (e.g., `grospc`, `minipc`).                |
| `homes/`    | User-specific Home Manager configurations (e.g., `bigor@grospc`).       |
| `modules/`  | Reusable custom modules. Split into `nixos` (system) and `home` (user). |
| `packages/` | Custom packages (overlays), such as `turtle-wow`.                       |
| `dotfiles/` | Raw configuration files (xdg), specifically for the **Cosmic Desktop**. |
| `checks/`   | CI/CD checks and linters.                                               |

### Namespace

Custom options defined in this repository are namespaced under **`bigor`**.

- Example: `bigor.roles.desktop`, `bigor.services.nfs.client`.

## Systems

| Hostname   | Role                     | Architecture   |
| :--------- | :----------------------- | :------------- |
| **grospc** | Main Desktop Workstation | `x86_64-linux` |
| **minipc** | Secondary Node / Server  | `x86_64-linux` |

## Usage & Development

### Common Commands

**Rebuild the system:**

```bash
sudo nixos-rebuild switch --flake .
```

**Update dependencies:**

```bash
nix flake update
```

**Format code:**
This project uses `treefmt` for formatting.

```bash
nix fmt
```

### Module Development

When adding new functionality:

1.  Create a module in `modules/nixos/` (system) or `modules/home/` (user).
2.  Define options using `lib.mkOption`.
3.  Implement functionality behind `config.bigor.<path>.enable`.
4.  Import/Enable the module in the relevant `systems/` or `homes/` file.

### Directory Details

- **`flake.nix`**: The entry point. Inputs define `nixpkgs` (branch `nixos-25.11`), `snowfall-lib`, and `home-manager`.
- **`dotfiles/cosmic/`**: Contains explicitly tracked dconf/settings for the System76 Cosmic Desktop environment.
