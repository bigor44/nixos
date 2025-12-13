# ❄️ Bigor's NixOS Configuration

Welcome to my personal **NixOS** configuration repository. This setup is fully declarative, managed with **Nix Flakes**, and structured using the opinionated [Snowfall Lib](https://github.com/snowfallorg/lib).

It powers my personal infrastructure, ranging from a high-performance gaming desktop running the **COSMIC Desktop Environment** (Alpha) to a headless homelab server.

![NixOS](https://img.shields.io/badge/NixOS-25.11-blue.svg)
![Snowfall](https://img.shields.io/badge/Managed_with-Snowfall_Lib-89b4fa.svg)
![COSMIC](https://img.shields.io/badge/Desktop-COSMIC-d08770.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Key Features

- **Structure:** Built with **Snowfall Lib** for automatic module discovery and a clean directory layout.
- **Desktop Environment:** Early adopter of **COSMIC DE** (by System76) on the main workstation, with custom dotfiles management via symlinks.
- **Editor:** Fully configured **Neovim** setup using **Nixvim**, featuring:
  - **LSP:** Auto-configured for Nix, Lua, Python, etc.
  - **Completion:** Powered by the blazing fast **blink-cmp**.
  - **UI:** Enhanced with `noice`, `trouble`, and `neo-tree`.
- **Gaming:** Optimized with `linuxPackages_zen`, Gamemode, and custom packages (like a Wayland-patched Turtle WoW client).
- **Homelab Services:**
  - **AdGuard Home:** Declarative configuration with local DNS rewrites managed via Nix.
  - **Tailscale:** Configured as an **Exit Node** with **UDP GRO forwarding** enabled for maximum throughput.
  - **NFS:** Centralized storage sharing (Server on `minipc`, Client on `grospc`).
  - **Caddy:** Reverse proxy with internal CA trust.

## 🏗️ Architecture

The repository follows the standard Snowfall Lib structure:

```text
├── certs/          # Local certificates (Internal CA)
├── checks/         # CI/CD checks (nix-lint via statix/deadnix)
├── dotfiles/       # Mutable configuration files (COSMIC applets, wallpapers, autostart)
├── homes/          # Home Manager configurations (users)
│   └── x86_64-linux/
│       ├── bigor@grospc    # Desktop user config
│       └── bigor@minipc    # Server user config
├── modules/        # Modular configuration blocks
│   ├── home/       # Home Manager modules (shell, git, gui-packages)
│   └── nixos/      # NixOS modules (api, desktop, services, nixvim, gaming, ...)
├── packages/       # Custom packages (e.g., turtle-wow)
├── scripts/        # Helper scripts (post-install, review)
├── systems/        # Host configurations
│   └── x86_64-linux/
│       ├── grospc  # Main Desktop
│       └── minipc  # Homelab Server
└── flake.nix       # Entry point

```

| ##🖥️ Hosts | Hostname    | Role                                                                               | Description    | IP  |
| ---------- | ----------- | ---------------------------------------------------------------------------------- | -------------- | --- |
| **grospc** | Workstation | Gaming rig, COSMIC Desktop, NFS Client. Uses **Zen Kernel** & `amd_pstate`.        | `192.168.1.11` |
| **minipc** | Server      | Headless Homelab, NFS Server, AdGuard Home, Tailscale Exit Node (UDP GRO enabled). | `192.168.1.10` |

##🛠️ Custom RolesI use a custom option system defined in `modules/nixos/api/default.nix` to easily assign roles to machines:

- **`bigor.roles.desktop`**: Enables GUI, Pipewire, Fonts, and Gaming optimizations.
- **`bigor.roles.homelab_master`**: Enables Server services, NFS Server, and network optimizations.

##🚀 Installation & Usage###1. Clone the repository```bash
git clone [https://github.com/bigor44/nixos.git](https://github.com/bigor44/nixos.git) ~/nixos
cd ~/nixos

````

###2. Post-Install BootstrappingA helper script is available to quickly set up the hardware configuration and state version for a new machine:

```bash
./scripts/post_install.sh

````

###3. Update the systemTo apply the configuration for the current hostname:

```bash
# Using 'nh' (recommended, included in the config)
nh os switch

# Or using standard nix tools
sudo nixos-rebuild switch --flake .

```

###4. Code Review / SharingTo aggregate the entire configuration into a single Markdown file for review (or for LLM context):

```bash
./scripts/concat_config.sh output.md

```

##📦 Custom Packages\* **Turtle WoW**: A custom AppImage wrapper for the Turtle WoW client, patched with `LD_PRELOAD` to inject `wayland-client` and `wayland-cursor` libraries for native Wayland compatibility.

##📄 LicenseThis project is licensed under the **MIT License** - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

```

```
