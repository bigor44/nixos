# Bigor's NixOS Configuration

A declarative NixOS configuration using Nix Flakes and Snowfall Lib to manage multiple systems with a modular, maintainable architecture.

## Overview

This repository contains my personal NixOS system configurations for multiple hosts, featuring:

- **Modular Architecture**: Snowfall Lib-based organization with reusable modules
- **Declarative Everything**: System configuration, user environments, and secrets
- **Multi-Host Support**: Manage desktop workstations and homelab servers
- **Modern Desktop**: COSMIC DE with gaming optimizations
- **Homelab Services**: DNS (Blocky + Unbound), reverse proxy (Caddy), NFS file sharing
- **Secrets Management**: Encrypted with sops-nix and age
- **Quality Assured**: Automated formatting and linting checks

## Hosts

| Host | Type | Profile | Description |
|------|------|---------|-------------|
| **grospc** | Workstation | `workstation` | Desktop with COSMIC DE, gaming (Steam, GameMode), AMD optimizations |
| **minipc** | Server | `homelab-master` | DNS/network services (Blocky, Unbound, Caddy, NFS) |
| **minidesk** | Workstation | `workstation` | Portable workstation (no NFS mount) |

## Features

### System Features
- **Desktop Environment**: COSMIC DE (System76's Rust-based desktop)
- **Audio**: PipeWire with ALSA support
- **Gaming**: Steam with GameMode optimizations
- **Networking**: Centralized topology with static IPs and automated `/etc/hosts`
- **Security**: Encrypted secrets with sops-nix, nftables firewall

### Homelab Services
- **DNS**: Blocky (ad-blocking DNS proxy) → Unbound (recursive resolver)
- **Reverse Proxy**: Caddy with automatic HTTPS
- **File Sharing**: NFS server/client
- **Remote Access**: OpenSSH server

### Development Tools
- **Editor**: NixVim with LSP, treesitter, completion
- **Shell**: Fish with Tide prompt, fzf, zoxide
- **CLI Tools**: eza, fd, ripgrep, btop, lazygit, bat
- **Code Quality**: treefmt, statix, deadnix

## Prerequisites

- NixOS 23.11 or later (using nixos-unstable)
- Age key for secrets management (optional, for secrets decryption)
- [nh](https://github.com/viperML/nh) - Nix Helper (recommended)

## Quick Start

### Initial Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bigor44/nixos.git
   cd nixos
   ```

2. **Generate hardware configuration** for your host:
   ```bash
   nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
   ```

3. **Run post-install script** (copies hardware config to the correct location):
   ```bash
   bash scripts/post_install.sh <hostname>
   ```

4. **Create a new host configuration** in `systems/x86_64-linux/<hostname>/default.nix`

5. **Apply the configuration**:
   ```bash
   nh os switch
   ```

### Updating an Existing Host

```bash
# Switch to new configuration
nh os switch

# Update flake inputs
nix flake update

# Rebuild with updated inputs
nh os switch
```

## Project Structure

```
.
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked dependency versions
├── modules/
│   ├── nixos/                   # System-level NixOS modules
│   │   ├── features/            # Modular features (audio, desktop, gaming, etc.)
│   │   ├── profiles/            # Composite configurations (workstation, homelab_master)
│   │   └── services/            # Network services (blocky, caddy, nfs, etc.)
│   └── home/                    # Home Manager modules
│       ├── cli-packages/        # Modern CLI tools
│       ├── git/                 # Git configuration
│       ├── shell/               # Fish shell with Tide prompt
│       ├── nixvim/              # Neovim configuration
│       └── features/            # User-level features
├── systems/x86_64-linux/        # Host-specific NixOS configurations
│   ├── grospc/
│   ├── minipc/
│   └── minidesk/
├── homes/x86_64-linux/          # Host-specific Home Manager configurations
│   ├── bigor/                   # Base user config
│   ├── bigor@grospc/            # Desktop user config
│   └── bigor@minipc/            # Server user config
├── dotfiles/                    # Symlinked configuration files
│   └── cosmic/                  # COSMIC DE configuration
├── secrets/                     # Encrypted secrets (sops-nix)
│   └── secrets.yaml
├── checks/x86_64-linux/         # Automated quality checks
│   ├── nix-fmt/                 # Formatting verification
│   └── nix-lint/                # Linting checks
└── scripts/                     # Utility scripts
    ├── post_install.sh          # Host setup automation
    ├── concat_config.sh         # Configuration concatenation utility
    └── dns-test.sh              # DNS testing utility
```

## Common Commands

### System Management
```bash
# Rebuild and switch to new configuration
nh os switch

# Build without switching
nh os build

# Test configuration (reverts on reboot)
nh os test

# Build specific host
nh os switch --hostname minipc
```

### Development
```bash
# Format code
nix fmt

# Check for dead code
deadnix --fail .

# Lint code
statix check --ignore .* .

# Run all checks
nix flake check

# Update dependencies
nix flake update
```

### Secrets Management
```bash
# Edit secrets (requires age key)
sops secrets/secrets.yaml

# View encrypted secrets
sops -d secrets/secrets.yaml
```

## Network Topology

The network configuration is centralized and declarative:

```nix
bigor.network.hosts = {
  minipc   = { ip = "192.168.1.10"; interface = "enp2s0"; };
  grospc   = { ip = "192.168.1.11"; interface = "enp14s0"; };
  minidesk = { ip = null; interface = "enp2s0"; };  # DHCP
};
```

This generates `/etc/hosts` entries automatically and provides consistent IP addressing throughout the configuration.

## Module System

All features are modular and can be enabled/disabled:

```nix
# In your host configuration
bigor.nixos.features.audio.enable = true;
bigor.nixos.features.gaming.enable = true;
bigor.home.shell.enable = true;
```

Profiles compose multiple related features:

```nix
# profiles/workstation/default.nix
bigor.nixos.profiles.workstation.enable = true;
# Enables: desktop, audio, bluetooth, gaming, fonts
```

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the development workflow and quality standards.

## Documentation

- [CLAUDE.md](CLAUDE.md) - Guidance for Claude Code when working with this repository
- [CONTRIBUTING.md](CONTRIBUTING.md) - Development workflow and contribution guidelines

## License

MIT License - Copyright (c) 2025 bigor44

See [LICENSE](LICENSE) for full license text.

## Acknowledgments

- [Snowfall Lib](https://github.com/snowfallorg/lib) - Flake organization framework
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [Sops-Nix](https://github.com/Mic92/sops-nix) - Secrets management
- [NixVim](https://github.com/nix-community/nixvim) - Declarative Neovim configuration
- [COSMIC DE](https://github.com/pop-os/cosmic-epoch) - Modern desktop environment
