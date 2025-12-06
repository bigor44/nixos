# Bigor's NixOS Flake Configuration

Welcome to **Bigor's NixOS Flake Configuration**. This repository manages the NixOS system configurations for my personal infrastructure, unifying system-level setup (NixOS) and user-level customization (Home Manager) into a single reproducible **Nix Flake**.

## 🌟 Overview

This project uses modern NixOS practices:

- **Flakes**: For hermetic and reproducible builds.
- **Home Manager**: For managing dotfiles and user packages.
- **Treefmt**: For a unified formatting toolchain.
- **Pre-commit hooks**: For ensuring code quality and secrets safety.

## 📂 Project Structure

```
├── flake.nix        # Entry point: defines inputs (Nixpkgs) and outputs (Systems)
├── hosts/           # Host-specific configurations
│   ├── grospc/      # Main Desktop (Gaming, Dev)
│   └── minipc/      # Home Server (Homelab, NAS)
├── modules/         # Reusable modules
│   ├── nixos/       # System-level modules (Roles, Services, Core)
│   └── home/        # User-level modules (Shell, GUI, Dotfiles)
├── dotfiles/        # Raw configuration files (symlinked via Home Manager)
├── scripts/         # Utility scripts
└── certs/           # Custom certificates
```

## 🖥️ Systems

| Host         | Type    | Branch         | Description                                              |
| :----------- | :------ | :------------- | :------------------------------------------------------- |
| **`grospc`** | Desktop | Stable (25.11) | High-performance workstation (Zen Kernel). Gaming & Dev. |
| **`minipc`** | Server  | Stable (25.11) | Home infrastructure. NFS Server, Tailscale optimized.    |

## 🚀 Getting Started

### Prerequisites

- Nix installed with Flakes enabled.
- `nh` (Nix Helper) is recommended for applying configurations.

### Applying Configuration

Apply the configuration for the current hostname:

```bash
nh os switch
```

Apply for a specific host:

```bash
nh os switch --hostname minipc
```

### Managing Dependencies

Update all flake inputs:

```bash
nix flake update
```

## 🛠️ Development

Enter the development environment with all necessary tools (LSP, Formatters, Linters):

```bash
nix develop
```

### Code Quality

This project enforces strict code quality standards.

**Formatting:**
Run `treefmt` to format all files (Nix, Lua, Shell, Prettier, etc.):

```bash
treefmt
```

**Linting:**
Run pre-commit checks manually:

```bash
nix build .#checks.x86_64-linux.pre-commit-check
```

## 🧩 Key Modules

### Roles

- **`roles.desktop`**: Enables COSMIC DE, audio, fonts, and GUI apps.
- **`roles.homelab_master`**: Enables headless server services (Caddy, Dashboard, Glances).

### Services

- **NFS**: `minipc` acts as the server (`/mnt/storage`), `grospc` as the client.
- **Tailscale**: VPN mesh with UDP GRO optimization on `minipc`.
- **Security**: SSH with secure defaults, AdGuard Home.
