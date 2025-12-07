# Bigor's NixOS Flake Configuration

Welcome to **Bigor's NixOS Flake Configuration**. This repository manages the system configurations for my personal infrastructure, unifying system-level setup (NixOS) and user-level customization (Home Manager) into a single, reproducible **Nix Flake**.

## 🌟 Features

- **Reproducibility**: Entire system state defined in code (Infrastructure as Code).
- **Atomic Upgrades**: Risk-free updates with the ability to rollback anytime.
- **Unified Styling**: Code formatting enforced via `treefmt` (Nix, Lua, Shell, etc.).
- **Modular Design**: Reusable modules for roles (Desktop, Server) and services.
- **Secrets Management**: Integration with `detect-secrets` to prevent accidental leaks.
- **Development Environment**: A robust `devShell` with all necessary tooling pre-configured.

## 📂 Project Structure

```bash
├── flake.nix          # Entry point: defines inputs (Nixpkgs) and outputs (Systems)
├── hosts/             # Host-specific configurations
│   ├── grospc/        # Main Desktop (Gaming, Dev)
│   └── minipc/        # Home Server (Homelab, NAS)
├── modules/           # Reusable modules
│   ├── nixos/         # System-level modules (Roles, Services, Core)
│   └── home/          # User-level modules (Shell, GUI, Dotfiles)
├── dotfiles/          # Raw configuration files (symlinked via Home Manager)
├── scripts/           # Utility scripts
└── certs/             # Custom certificates
```

## 🖥️ Systems

| Host         | Type    | Architecture   | Description                                              |
| :----------- | :------ | :------------- | :------------------------------------------------------- |
| **`grospc`** | Desktop | `x86_64-linux` | High-performance workstation (Zen Kernel). Gaming & Dev. |
| **`minipc`** | Server  | `x86_64-linux` | Home infrastructure. NFS Server, Tailscale optimized.    |

## 🚀 Getting Started

### Prerequisites

- **Nix** installed with **Flakes** enabled.
- **[nh](https://github.com/viperML/nh)** (Nix Helper) is highly recommended for faster and prettier builds.

### Applying Configuration

**For the current machine:**
```bash
nh os switch
```

**For a specific remote host (via SSH):**
```bash
nh os switch --hostname minipc
```

**Bootstrapping a new machine:**
If `nh` is not yet installed:
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

### Managing Dependencies

Update all flake inputs to their latest versions:
```bash
nix flake update
```

## 🛠️ Development

This project includes a comprehensive development environment.

**Enter the shell:**
```bash
nix develop
```

### Code Quality & Formatting

We use **Treefmt** to ensure consistent code style across the entire repository.

**Format all files:**
```bash
treefmt
```

**Run Linting Checks:**
We use pre-commit hooks to catch issues before they are committed.
```bash
nix build .#checks.x86_64-linux.pre-commit-check
```

## 🧩 Customization Guide

### Adding a User Package
Edit `modules/home/packages.nix` and add the package to the list:
```nix
home.packages = with pkgs; [
  ripgrep
  # ... other packages
];
```

### Modifying System Options
Edit `modules/nixos/core/options.nix` to define new flags, then implement them in the relevant module (e.g., `modules/nixos/services/myservice.nix`).

## 📜 License

[MIT](LICENSE)