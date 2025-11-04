# NixOS Configuration Repository

This repository contains my personal NixOS configuration, including modules for
desktop environments, servers, development tools, and more. It's designed to be
modular, maintainable, and easy to deploy using Nix flakes.

## 📁 Project Structure

```
.
├── flake.nix                 # Main flake definition
├── flake.lock                # Lock file for reproducible builds
├── hardware-configuration.nix # Hardware-specific configuration (generated)
├── hosts/                    # Host-specific configurations
│   └── minipc/               # Configuration for 'minipc' host
│       ├── configuration.nix # Main host config
│       └── hardware-configuration.nix # Hardware config for this host
├── modules/                  # Reusable configuration modules
│   ├── options.nix           # Module options
│   ├── audio.nix             # Audio configuration
│   ├── bluetooth.nix         # Bluetooth support
│   ├── desktop-apps.nix      # Desktop applications
│   ├── desktop-env.nix       # Desktop environment (Cosmic)
│   ├── fonts.nix             # Font configuration
│   ├── gc.nix                # Garbage collection settings
│   ├── locale.nix            # Locale and timezone settings
│   ├── monitoring.nix        # Prometheus node exporter
│   ├── network.nix           # Network configuration (NetworkManager, nftables)
│   ├── neovim.nix            # Neovim configuration via nvf
│   ├── ollama.nix            # Ollama and Open WebUI for LLMs
│   ├── podman.nix            # Podman container setup
│   ├── podman-home-assistant.nix # Home Assistant container
│   ├── ssh.nix               # SSH server settings
│   ├── users.nix             # User management
│   └── ...                   # Other modules
└── README.md                 # This file
```

## 🧰 Features

### 🔧 Host Configuration

- **Host**: `minipc`
- **Architecture**: x86_64-linux
- **System Type**: Desktop (Cosmic DE)
- **Hardware**: Custom PC with GPU acceleration

### 🖥️ Desktop Environment

- **DE**: [Cosmic](https://github.com/pop-os/cosmic)
- **Display Manager**: Cosmic Greeter
- **Applications**:
  - Firefox
  - Steam
  - Discord
  - Brave
  - OneDrive
  - WhatsApp Electron

### 🧑‍💻 Development Tools

- **Editor**: Neovim (via [nvf](https://github.com/Neovim-from-scratch/nvf))
- **Languages**:
  - Nix (with `nil`, `nixfmt`)
  - Markdown
  - Bash
- **LSP Support**: Treesitter, LSP integration
- **Git Integration**: Gitsigns

### 🌐 Networking

- **Network Manager**: Enabled with custom DNS
- **Firewall**: nftables
- **Hosts File**: Local DNS entries for devices on LAN

### 🔐 Security

- **SSH Server**: Enabled with passwordless login (key-based)
- **Sudo**: Wheel group doesn't require password
- **Root Login**: Disabled

### 📊 Monitoring & Dashboard

- **Prometheus Node Exporter**: Enabled
- **Grafana & Prometheus**: Dashboard for system metrics
- **Garbage Collection**: Automated weekly cleanup

### 🤖 AI / LLM Support

- **Ollama**: Local LLM inference with ROCm acceleration
- **Open WebUI**: Web interface for interacting with models

### 🐳 Containerization

- **Podman**: Container engine with Docker compatibility
- **Home Assistant**: Containerized instance

## 🛠️ Deployment

### Prerequisites

- NixOS 24.05 or later
- Nix with flakes enabled

### Setup Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/bigor/nixos-config.git
   cd nixos-config
   ```

2. **Update Hardware Configuration** On your target machine:
   ```bash
   nixos-generate-config --force --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/<hostname>/
   ```

3. **Deploy**
   ```bash
   sudo nixos-rebuild switch --flake .#minipc
   ```

## 📦 Included Modules

| Module                      | Description                  |
| --------------------------- | ---------------------------- |
| `audio.nix`                 | Audio configuration          |
| `bluetooth.nix`             | Bluetooth support            |
| `desktop-apps.nix`          | Desktop applications         |
| `desktop-env.nix`           | Cosmic desktop environment   |
| `fonts.nix`                 | Console and GUI fonts        |
| `gc.nix`                    | Garbage collection settings  |
| `locale.nix`                | Locale and timezone          |
| `monitoring.nix`            | Prometheus node exporter     |
| `network.nix`               | Network configuration        |
| `neovim.nix`                | Neovim with full LSP support |
| `ollama.nix`                | Ollama and Open WebUI        |
| `podman.nix`                | Podman containers            |
| `podman-home-assistant.nix` | Home Assistant container     |
| `ssh.nix`                   | SSH server settings          |
| `users.nix`                 | User and sudo configuration  |

## 📝 Notes

- This configuration uses `nvf` for Neovim configuration (Neovim from Scratch).
- The system is set to French locale and timezone.
- SSH keys are configured for `bigor` user.
- All modules are optional and can be enabled/disabled via the options in
  `options.nix`.

## 📄 License

MIT License - see `LICENSE` for details.
