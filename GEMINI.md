# Gemini Context: Bigor's NixOS Configuration

This documentation provides context for the Gemini AI agent interacting with this NixOS configuration repository.

## Project Overview

This is a **NixOS configuration** repository managed with **Nix Flakes**. It defines the system state for two primary machines:

1.  **grospc**: A high-performance desktop workstation running the **COSMIC** desktop environment.
2.  **minipc**: A headless home lab server running various services (NFS, AdGuard Home, Caddy, Tailscale).

The project enforces **reproducibility** and **declarative configuration** for both the operating system (NixOS) and the user environment (Home Manager).

## Architecture

The codebase follows a modular structure:

- **`flake.nix`**: The entry point. Defines inputs (NixOS 25.11, Home Manager, NixVim, etc.) and outputs (`nixosConfigurations`).
- **`systems/<arch>/<hostname>/`**: Host-specific configurations.
  - `default.nix`: Entry point for the host, importing hardware config and enabling specific roles.
  - `hardware-configuration.nix`: Hardware-specific settings (filesystems, boot loader).
- **`modules/nixos/`**: Reusable NixOS modules.
  - `core/`: Base configuration shared by all systems (locale, users, base packages).
  - `desktop/`: GUI-related modules (COSMIC, audio, fonts, gaming).
  - `services/`: Server services (SSHD, NFS, AdGuard, Caddy, Tailscale).
- **`modules/home/`**: Home Manager configuration for the user `bigor`.
  - `dotfiles.nix`: Manages dotfiles linking.
  - `packages.nix`: User-specific packages.
- **`dotfiles/`**: Raw configuration files (e.g., for COSMIC applications) symlinked by Home Manager.

## Key Systems

### grospc (Desktop)

- **Role**: Gaming & Development.
- **OS**: NixOS 25.11.
- **Desktop**: COSMIC (System76).
- **Features**: Steam, GameMode, Pipewire, AMD P-State optimizations.
- **Network**: `192.168.1.11` (Static). NFS Client.

### minipc (Server)

- **Role**: Home Lab / Infrastructure.
- **OS**: NixOS 25.11 (Headless).
- **Services**:
  - **NFS Server**: Exports `/mnt/storage`.
  - **AdGuard Home**: DNS & Ad blocking (`https://adguard.bigor.lan`).
  - **Caddy**: Reverse proxy with internal CA.
  - **Tailscale**: VPN exit node.
- **Network**: `192.168.1.10` (Static).

## Development Workflow

### Environment Setup

Enter the development shell to get all necessary tools (formatters, LSP, git hooks):

```bash
nix develop
```

### Common Commands

- **Rebuild System (Recommended):**
  ```bash
  nh os switch
  ```
- **Rebuild System (Standard):**
  ```bash
  sudo nixos-rebuild switch --flake .#<hostname>
  ```
- **Format Code:**
  ```bash
  nix fmt
  ```
- **Run Checks (Lint/Format):**
  ```bash
  nix flake check
  ```
- **Update Dependencies:**
  ```bash
  nix flake update
  ```

## Coding Conventions

- **Language**: Nix.
- **Formatting**: Strictly enforced via `treefmt`.
  - Nix: `alejandra`
  - Lua: `stylua`
  - Shell: `shfmt`
  - Python: `black`
  - Web: `prettier`
- **Style**:
  - Prefer modular configuration over monolithic files.
  - Use `bigor.roles.*` and `bigor.services.*` options to enable features.
  - Keep secrets out of the repository (use sops-nix if added in future, currently not present).

## Key Files & Paths

| Path                                      | Description                            |
| :---------------------------------------- | :------------------------------------- |
| `flake.nix`                               | Flake definition, inputs, and outputs. |
| `modules/nixos/core/options.nix`          | Custom option definitions (`bigor.*`). |
| `systems/x86_64-linux/grospc/default.nix` | Main config for the desktop.           |
| `modules/nixos/desktop/desktop-env.nix`   | COSMIC desktop configuration.          |
| `modules/home/default.nix`                | Home Manager entry point.              |

## User Notes

- The project uses `nh` (Nix Helper) for faster and cleaner rebuilds.
- The `dotfiles/` directory contains configuration for COSMIC applications which are not yet fully declaratively manageable via Nix options, so they are symlinked.
