# ❄️ Bigor's NixOS Configuration

![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg?style=flat-square&logo=nixos)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)
![Built With](https://img.shields.io/badge/Built%20With-Nix%20Flakes-bfc0c0?style=flat-square&logo=nix)

Welcome to my personal infrastructure configuration repository. This project manages my physical machines using **NixOS**, **Nix Flakes**, and **Home Manager**, ensuring a reproducible, immutable, and declarative system state across my network.

## 🖥️ Hosts Overview

This configuration currently manages the following systems:

| Hostname     | Role       | Description                   | Key Features                                                                                                                   |
| :----------- | :--------- | :---------------------------- | :----------------------------------------------------------------------------------------------------------------------------- |
| **`grospc`** | 🎮 Desktop | Main workstation & Gaming rig | • Kernel: `linuxPackages_zen`<br>• GPU: Performance mode<br>• Storage: Dedicated `/steamlibrary` mount<br>• Network: `enp14s0` |
| **`minipc`** | ☁️ Server  | Home Lab & Services           | • CPU: AMD P-State optimization<br>• Network: UDP GRO (Tailscale optimization)<br>• Services: Vaultwarden, AdGuard, Caddy, NFS |

## 🏗️ Architecture

The codebase is organized to separate system-level configuration from user-level dotfiles, utilizing a "Role" based approach.

### Directory Structure

```bash
├── flake.nix             # Entry point & dependency definitions
├── hosts/                # Host-specific configurations
│   ├── grospc/           # Hardware & specific overrides for Desktop
│   └── minipc/           # Hardware & specific overrides for Server
├── modules/
│   ├── nixos/            # System-level modules
│   │   ├── roles/        # Meta-modules (desktop, server, hybrid)
│   │   ├── services/     # Individual service configs (Caddy, Tailscale...)
│   │   └── core/         # Base system settings (Locale, Users...)
│   └── home/             # Home Manager (User-level) modules
│       ├── dotfiles/     # App configs (Cosmic DE, Autostart...)
│       └── ...           # Neovim, Git, Shell configurations
└── scripts/              # Utility scripts
```

### Role System

Instead of importing every service manually per host, I use roles defined in `modules/nixos/roles/`:

- **Desktop:** Enables GUI, Sound, Bluetooth, NFS Client.
- **Server:** Enables SSH, Dashboard, Tailscale, AdGuard, NFS Server, Reverse Proxy.

## 💾 Backup Strategy

The infrastructure includes an automated backup workflow for critical data (like Vaultwarden passwords):

1.  **Source:** `minipc` (Server) hosts the Vaultwarden instance and exposes backups via NFS.
2.  **Destination:** `grospc` (Desktop) mounts the NFS share.
3.  **Sync:** A systemd service (`pull-vaultwarden-backups`) on `grospc` runs daily to:
    - Pull encrypted backups from `minipc`.
    - Store them on the local physical disk (`/steamlibrary`).
    - Enforce a 90-day retention policy.

## 🛠️ Development & Tooling

This project uses a **devShell** provided by the flake to ensure a consistent development environment.

### Entering the Shell

```bash
nix develop
```

This activates the following tools:

- **Language Servers:** `nixd`, `lua-language-server`
- **Formatters:** `alejandra` (Nix), `stylua` (Lua), `shfmt` (Bash), `prettier`
- **Linters:** `statix`, `deadnix`, `detect-secrets`

### Quality Checks (Pre-commit)

Git hooks are configured to run automatically before commits. You can also run them manually:

```bash
# Run all checks
nix build .#checks.x86_64-linux.pre-commit-check
```

## 🚀 Usage

### Applying Configuration

This project uses [`nh`](https://github.com/viperML/nh) for faster and prettier builds.

To apply the configuration to the current machine:

```bash
nh os switch .
```

To apply to a specific host (e.g., `minipc`):

```bash
nh os switch -H minipc .
```

### Updating Dependencies

To update `nixpkgs` and other flake inputs:

```bash
nix flake update
```

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
