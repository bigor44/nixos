# 🐧 Bigor's NixOS Configuration

A modular, reproducible NixOS configuration managed with flakes and Home Manager. Built with a clear separation of platform infrastructure and optional features.

## ✨ Features

- **Modular Architecture**: Platform modules (always active) vs. feature modules (optional features)
- **Multi-Host Support**: Configurations for desktop, server, and laptop
- **Quality Assurance**: Built-in validation scripts (formatting, linting, dead code detection)
- **Network Topology**: Centralized network configuration (IPs, ports, domain)
- **Secret Management**: SOPS + age for encrypted secrets
- **Development Workflow**: Pre-commit hooks and safe rebuild workflows
- **Home Manager Integration**: User-level configuration with nixvim

## 🏗️ Architecture

### Core Principles

1. **Platform vs. Features**:
   - **Platform**: Always-active infrastructure (boot, network, users, policies)
   - **Features**: Optional features gated by `enable` options (desktop, gaming, services)

2. **Policy-Driven Configuration**:
   - DNS strategy (server, client, standalone)
   - Storage strategy (nfs-server, nfs-client, local, none)
   - Network topology centralized in `nix/network-topology.nix`

3. **Quality First**:
   - Automatic formatting with `nix fmt`
   - Linting with statix and dead code detection
   - Pre-commit hooks for validation
   - Safe rebuild workflows with `nrs`/`nrb`

### System Architecture

```
     ┌─────────────────────────────────────┐
     │     Network Topology (Data)         │
     │  IPs, Ports, Domain, Interfaces     │
     └──────────────┬──────────────────────┘
                    │ injected via specialArgs
     ┌──────────────▼──────────────────────┐
     │         Host Configuration          │
     │  ┌──────────────┐  ┌──────────────┐ │
     │  │   Policies   │  │   Features   │ │
     │  │  DNS Storage │  │ Desktop, ... │ │
     │  └──────┬───────┘  └──────────────┘ │
     │         │ auto-enables               │
     │         ▼                             │
     │  Required Features (if needed)       │
     └──────────────────────────────────────┘
```

## 🗂️ Directory Structure

```
nixos/
├── certs/                  # SSL certificates
├── dotfiles/               # Static dotfiles (linked via Home Manager)
├── hosts/                  # Host-specific configurations
│   ├── grospc/            # Desktop workstation
│   ├── minipc/            # Home server
│   └── minidesk/          # Portable laptop
├── modules/               # Reusable modules
│   ├── nixos/            # NixOS modules
│   │   ├── platform/     # Platform infrastructure
│   │   └── features/     # Optional features
│   └── home/             # Home Manager modules
├── nix/                   # Flake parts
├── scripts/               # Utility scripts
├── secrets/               # Encrypted secrets
└── users/                 # User configurations
```

## 🚀 Getting Started

### Prerequisites

- NixOS with flakes enabled
- Git
- Basic Nix knowledge

### Quick Start

1. **Clone the repository**:

   ```bash
   git clone https://github.com/bigor44/nixos.git ~/nixos
   cd ~/nixos
   ```

2. **Enter development shell** (auto-installs tools and hooks):

   ```bash
   nix develop
   ```

3. **Check configuration**:
   ```bash
   nix flake check
   ```

### Building for a Specific Host

```bash
# Build configuration for grospc
nix build .#nixosConfigurations.grospc.config.system.build.toplevel

# Switch to configuration (with validation)
nrs
```

## 🛠️ Development Workflow

### Quality Assurance Commands

| Command       | Description                             | When to Use           |
| ------------- | --------------------------------------- | --------------------- |
| `check-quick` | Fast incremental check (<0.1s)          | During development    |
| `check-full`  | Complete CI-equivalent check (~16s)     | Before commits/pushes |
| `check-mega`  | Intelligent check (adapts to git state) | General use           |
| `nix fmt`     | Format all Nix files                    | After editing files   |
| `dns-test`    | DNS stack functional test               | After DNS changes     |

### Safe Workflow Aliases

- **`gcn`**: Format + add all + check staged + commit
- **`gps`**: Full check + push
- **`nrs`**: Full check + rebuild switch (recommended)
- **`nrb`**: Full check + rebuild boot

### Typical Workflow

```bash
# 1. Make changes
vim modules/nixos/features/example.nix

# 2. Format and validate
nix fmt
check-quick

# 3. Commit safely
gcn -m "Add new feature"

# 4. Push safely
gps

# 5. Rebuild system
nrs
```

## 🖥️ Host Configurations

### grospc (Desktop Workstation)

- **Kernel**: Zen (performance optimized)
- **DNS**: Client mode (uses minipc as resolver)
- **Storage**: NFS client (mounts from minipc)
- **Features**: Desktop, audio, flatpak, bluetooth, gaming, blocky, VIA keyboard

### minipc (Home Server)

- **Kernel**: LTS (stability focused)
- **DNS**: Server mode (serves DNS to LAN)
- **Storage**: NFS server (exports storage)
- **Features**: Caddy, Blocky, SSH, NFS, Gatus

### minidesk (Portable Laptop)

- **Kernel**: Zen (performance optimized)
- **DNS**: Standalone mode (DoH upstreams, no LAN dependency)
- **Storage**: Local storage
- **Features**: Desktop, audio, flatpak, bluetooth, gaming, blocky, SSH

## 🔧 Module System

The codebase uses three module types:

### Platform Modules (`modules/nixos/platform/`)

Always-active infrastructure with no `enable` options. Includes boot, fonts, localization, network, packages, SOPS, users, and strategic policies (DNS, storage).

### Feature Modules (`modules/nixos/features/`)

Optional functionality enabled via `bigor.features.<name>.enable`. Includes desktop environment (COSMIC), audio (PipeWire), gaming (Steam), services (Caddy, Blocky, SSH, NFS, Gatus), hardware support (Bluetooth, VIA keyboard), and system utilities (Flatpak, power management).

See `nix/modules.nix` for the complete and authoritative list of all modules.

### Home Manager Modules (`modules/home/`)

User-level configuration including CLI tools, development scripts, git configuration, GUI applications, nixvim (Neovim), shell configuration (Zsh, Starship), and wallpaper synchronization.

## 🔐 Secret Management

Secrets are encrypted with [SOPS](https://github.com/getsops/sops) and [age](https://github.com/FiloSottile/age):

```bash
# Edit encrypted secrets
sops secrets/secrets.yaml

# View decrypted secrets
sops -d secrets/secrets.yaml
```

## 📡 Network Topology

Network configuration is centralized in `nix/network-topology.nix`:

```nix
{
  subnet = "192.168.1.0/24";
  domain = "bigor.lan";

  hosts = {
    minipc = { ip = "192.168.1.10"; interface = "enp2s0"; };
    grospc = { ip = "192.168.1.11"; interface = "enp14s0"; };
    minidesk = { ip = null; interface = "enp2s0"; }; # DHCP
  };
}
```

## 🧪 Testing

### DNS Stack Test

```bash
dns-test
```

Validates:

- Local DNS resolution
- Ad blocking effectiveness
- External resolution

### Format and Lint

```bash
nix fmt          # Format all files
check-full       # Complete validation
```

## 🔄 Updates

### Update All Inputs

```bash
nix flake update
```

### Update Specific Input

```bash
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager
nix flake lock --update-input nixvim
```

## 🐛 Troubleshooting

### Common Issues

1. **Formatting errors**:

   ```bash
   nix fmt
   ```

2. **Linting errors**:

   ```bash
   statix check .
   deadnix --fail .
   ```

3. **Evaluation errors**:

   ```bash
   nix flake check
   ```

4. **DNS not working**:
   ```bash
   dns-test
   systemctl status blocky
   ```

### Debugging

- Use `nix flake show` to see flake structure
- Use `nix eval .#nixosConfigurations.<host>.config` to inspect configuration
- Check systemd logs: `journalctl -u blocky`

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Flakes](https://nixos.wiki/wiki/Flakes)
- [SOPS](https://github.com/getsops/sops)

## 🤝 Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the process for submitting pull requests.

**Always run `check-full` before pushing changes!**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [NixOS Community](https://nixos.org/community/)
- [flake-parts](https://github.com/hercules-ci/flake-parts) for modular flakes
- [nixvim](https://github.com/nix-community/nixvim) for Neovim configuration
- [sops-nix](https://github.com/Mic92/sops-nix) for secret management

---

_Built with ❤️ and Nix_
