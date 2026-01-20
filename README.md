# Bigor's NixOS Configuration

Welcome to my personal NixOS configuration repository. This project uses **Nix Flakes** and a modular architecture to manage multiple machines with a consistent yet flexible setup.

## 🏗️ Architecture

This repository follows a strict separation of concerns to keep the configuration maintainable and reusable:

- **Platform Modules (`modules/nixos/platform/`)**: Mandatory infrastructure (boot, networking, shell, users). These are foundational and always active.
- **Feature Modules (`modules/nixos/features/`)**: Optional capabilities (gaming, desktop environments, development tools). These are toggled per-host using `bigor.features.<category>.<name>.enable`.
- **Hosts (`hosts/`)**: Machine-specific configurations that compose platform and feature modules.

## 🖥️ Hosts

| Host       | Purpose             | Hardware     |
| :--------- | :------------------ | :----------- |
| `grospc`   | Main Workstation    | x86_64-linux |
| `minipc`   | Home Server / Media | x86_64-linux |
| `minidesk` | Secondary Desktop   | x86_64-linux |

## 🚀 Key Features

- **Nix Flakes**: Fully reproducible builds.
- **Secrets Management**: Integrated **SOPS** with **age** via `sops-nix`.
- **NixVim**: Highly customized Neovim configuration managed through Nix.
- **Developer Experience**: Custom scripts for validation (`check-full`, `check-quick`) and deployment.
- **Formatting**: Automated formatting with `treefmt`.

## 🛠️ Getting Started

### Prerequisites

- A running NixOS system with `nix-command` and `flakes` enabled.

### Usage

1.  **Clone the repository**:

    ```bash
    git clone https://github.com/bigor44/nixos.git
    cd nixos
    ```

2.  **Enter the development shell**:

    ```bash
    nix develop
    ```

3.  **Build and Switch (for the current host)**:
    ```bash
    sudo nixos-rebuild switch --flake .#<hostname>
    ```

## 📝 Development

Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed information on:

- Naming conventions and headers.
- How to add new features or hosts.
- Using the validation scripts and aliases.
- Commit standards (`gcn`).

## ⚖️ License

This project is licensed under the [LICENSE](./LICENSE) file found in the root directory.
