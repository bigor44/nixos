# ❄️ Bigor's NixOS Configuration

Welcome to my personal **NixOS** configuration repository. This setup is fully declarative, managed with **Nix Flakes**, and structured using the opinionated [Snowfall Lib](https://github.com/snowfallorg/lib).

It powers my personal infrastructure, ranging from a high-performance gaming desktop running the **COSMIC Desktop Environment** to a headless homelab server.

![NixOS](https://img.shields.io/badge/NixOS-25.11-blue.svg)
![Snowfall](https://img.shields.io/badge/Managed_with-Snowfall_Lib-89b4fa.svg)
![COSMIC](https://img.shields.io/badge/Desktop-COSMIC-d08770.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Key Features

- **Structure:** Built with **Snowfall Lib** for automatic module discovery and a clean directory layout.
- **Desktop Environment:** Early adopter of **COSMIC DE** (by System76) on the main workstation.
- **Editor:** Fully configured **Neovim** setup using **Nixvim**, featuring LSP (Nix, Lua, Python), Treesitter, Telescope, and Neo-tree.
- **Gaming:** Optimized for gaming with Steam, Gamemode, and custom packages like a Wayland-wrapped Turtle WoW client.
- **Homelab Services:**
  - **AdGuard Home:** Network-wide ad blocking and local DNS.
  - **Tailscale:** VPN Mesh with Exit Node and UDP GRO optimizations.
  - **NFS:** Centralized storage sharing between the server and desktop.
  - **Caddy:** Reverse proxy with internal CA trust.
- **Code Quality:** Automated formatting and linting via `treefmt` (Alejandra, Stylua, Shfmt, Prettier).

## 🏗️ Architecture

The repository follows the standard Snowfall Lib structure:

```text
├── certs/          # Local certificates (Internal CA)
├── checks/         # CI/CD checks (nix-lint via statix/deadnix)
├── dotfiles/       # Raw configuration files (COSMIC applets, wallpapers, etc.)
├── homes/          # Home Manager configurations (users)
│   └── x86_64-linux/
│       ├── bigor@grospc    # Desktop user config
│       └── bigor@minipc    # Server user config
├── modules/        # Modular configuration blocks
│   ├── home/       # Home Manager modules (shell, git, gui-packages)
│   └── nixos/      # NixOS modules (api, desktop, services, nixvim, common, ...)
├── packages/       # Custom packages (e.g., turtle-wow)
├── systems/        # Host configurations
│   └── x86_64-linux/
│       ├── grospc  # Main Desktop
│       └── minipc  # Homelab Server
└── flake.nix       # Entry point

```

| ##🖥️ Hosts | Hostname    | Role                                                                   | Description    | IP  |
| ---------- | ----------- | ---------------------------------------------------------------------- | -------------- | --- |
| **grospc** | Workstation | Gaming rig, COSMIC Desktop, NFS Client, High Performance (Zen Kernel). | `192.168.1.11` |
| **minipc** | Server      | Headless Homelab, NFS Server, AdGuard Home, Tailscale Exit Node.       | `192.168.1.10` |

##🛠️ Custom RolesI use a custom option system defined in `modules/nixos/api/default.nix` to easily assign roles to machines:

- **`bigor.roles.desktop`**: Enables GUI, Pipewire, Fonts, and Gaming optimizations.
- **`bigor.roles.homelab_master`**: Enables Server services, Docker/Podman, and network optimizations.

##🚀 Installation & Usage###1. Clone the repository```bash
git clone [https://github.com/bigor44/nixos.git](https://github.com/bigor44/nixos.git) ~/nixos
cd ~/nixos

````

###2. Update the systemTo apply the configuration for the current hostname:

```bash
# Using 'nh' (recommended, included in the config)
nh os switch

# Or using standard nix tools
sudo nixos-rebuild switch --flake .

````

###3. FormattingTo ensure code quality before pushing:

```bash
nix fmt
# or
treefmt

```

##📦 Custom Packages\* **Turtle WoW**: A custom AppImage wrapper for the Turtle WoW client, patched for Wayland compatibility.

##📄 LicenseThis project is licensed under the **MIT License** - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

```

```
