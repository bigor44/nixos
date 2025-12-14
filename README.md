# 🐧 Bigor's NixOS Configuration

A declarative, modular NixOS configuration using flakes and [Snowfall Lib](https://github.com/snowfallorg/lib) for structure. This repository manages both a desktop workstation (`grospc`) and a headless home lab server (`minipc`).

## 🌟 Features

### Desktop Environment (`grospc`)

- **DE**: COSMIC Desktop Environment
- **Shell**: Fish with Tide prompt, fzf, zoxide
- **Editor**: Neovim (via NixVim) with full LSP, Treesitter, and modern plugins
- **Gaming**: Steam, GameMode optimizations
- **Performance**: Zen kernel, AMD P-State active mode, performance governor
- **Storage**: NFS client for accessing shared storage

### Home Lab Server (`minipc`)

- **Services**:
  - AdGuard Home (network-wide ad blocking + local DNS)
  - NFS Server (centralized storage)
  - Ollama (local AI models with Open WebUI)
  - Tailscale VPN (mesh networking + exit node)
  - Caddy (reverse proxy with automatic HTTPS)
- **Optimization**: UDP GRO forwarding for Tailscale, schedutil CPU governor
- **Security**: Hardened SSH (key-only auth, no root login)

### Development Tools

- **LSP Support**: Nix, Lua, Python, Bash, YAML, JSON, Markdown
- **Formatters**: alejandra, stylua, shfmt, prettier, black, isort, taplo
- **Linters**: statix, deadnix, selene
- **Git Integration**: Extensive Fish abbreviations, LazyGit in Neovim

## 📁 Project Structure

```
nixos/
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked dependency versions
├── treefmt.toml                 # Code formatting configuration
├── systems/x86_64-linux/        # Host-specific configurations
│   ├── grospc/                  # Desktop workstation
│   └── minipc/                  # Home lab server
├── modules/
│   ├── nixos/                   # System-level modules
│   │   ├── api/                 # Custom options API
│   │   ├── common/              # Base system configuration
│   │   ├── desktop/             # Desktop environment setup
│   │   ├── fonts/               # Font configuration
│   │   ├── gaming/              # Gaming optimizations
│   │   ├── packages/            # System packages
│   │   ├── services/            # Service configurations
│   │   └── users/               # User management
│   └── home/                    # Home Manager modules
│       ├── cli-packages/        # CLI tools
│       ├── git/                 # Git configuration
│       ├── gui-packages/        # Desktop applications
│       ├── nixvim/              # Neovim configuration
│       └── shell/               # Shell environment
├── homes/x86_64-linux/          # Home Manager configurations
│   ├── bigor/                   # Base user configuration
│   ├── bigor@grospc/            # Desktop user configuration
│   └── bigor@minipc/            # Server user configuration
├── packages/                    # Custom packages
│   └── turtle-wow/              # Turtle WoW game client
├── checks/                      # CI/CD checks
│   └── x86_64-linux/nix-lint/   # Nix linting
└── scripts/                     # Utility scripts
    ├── concat_config.sh         # Configuration aggregation
    └── post_install.sh          # Post-installation setup
```

## 🚀 Quick Start

### Initial Installation

1. **Boot NixOS installer** and clone this repository:

   ```bash
   nix-shell -p git
   git clone https://github.com/yourusername/nixos.git ~/nixos
   cd ~/nixos
   ```

2. **Create host configuration** (if not already present):

   ```bash
   mkdir -p systems/x86_64-linux/your-hostname
   # Add your default.nix and run hardware scan
   nixos-generate-config --show-hardware-config > systems/x86_64-linux/your-hostname/hardware-configuration.nix
   ```

3. **Install NixOS**:

   ```bash
   sudo nixos-install --flake .#your-hostname
   ```

4. **Run post-install script** (after reboot):
   ```bash
   cd ~/nixos
   ./scripts/post_install.sh
   ```

### Daily Usage

**Rebuild system** (with nh):

```bash
nh os switch
```

**Update flake inputs**:

```bash
nix flake update
```

**Format code**:

```bash
treefmt
```

**Check configuration**:

```bash
nix flake check
```

**Garbage collection** (automated via nh):

```bash
nh clean all --keep 3 --keep-since 4d
```

## 🔧 Configuration Options

### Custom API Options (`bigor.*`)

#### Roles

```nix
bigor.roles = {
  desktop = true;           # Enable full desktop environment
  homelab_master = true;    # Enable server services
};
```

#### Services

```nix
bigor.services = {
  ssh.enable = true;        # SSH daemon
  nfs.server = true;        # NFS server
  nfs.client = true;        # NFS client
  ollama.enable = true;     # Ollama AI service
};
```

#### Network

```nix
bigor.network = {
  mainInterface = "enp2s0";           # Primary network interface
  ips.grospc = "192.168.1.11";        # Desktop static IP
  ips.minipc = "192.168.1.10";        # Server static IP
};
```

### Home Manager Options (`bigor.home.*`)

```nix
bigor.home = {
  git.enable = true;           # Git configuration + Fish abbrs
  shell.enable = true;         # Fish + Tide + fzf + zoxide
  cli-packages.enable = true;  # Modern CLI tools
  gui-packages.enable = true;  # Desktop applications
  nixvim.enable = true;        # Neovim configuration
};
```

## 📦 Notable Packages

### CLI Tools

- **Modern replacements**: eza, fd, ripgrep, bat, btop
- **Development**: lazygit, statix, deadnix, treefmt
- **Network**: dig, tailscale
- **System**: inxi, fastfetch, lm_sensors

### Desktop Applications

- **Communication**: Discord, WhatsApp
- **Media**: YouTube Music, Brave browser
- **Gaming**: Steam, Turtle WoW (custom package)
- **Productivity**: OneDrive

### Neovim Plugins

- **Editor**: Telescope, Neo-tree, LazyGit
- **LSP**: Native LSP with multiple language servers
- **Completion**: Blink-cmp
- **UI**: Noice, Gitsigns, Mini.nvim suite
- **Formatting**: Conform.nvim with auto-format on save

## 🌐 Service Access

All services are accessible via local DNS (configured in AdGuard Home):

- **AdGuard Home**: https://adguard.bigor.lan
- **Ollama WebUI**: https://ai.bigor.lan
- **Main server**: https://bigor.lan

## 🔒 Security Features

- Hardened SSH (key-only authentication)
- No root login
- Passwordless sudo for wheel group
- Internal CA for local TLS certificates
- AdGuard Home for DNS-level protection
- Tailscale for secure remote access

## 🎨 Customization

### Adding a New Host

1. Create directory: `systems/x86_64-linux/hostname/`
2. Add `default.nix` with system configuration
3. Generate hardware config: `nixos-generate-config`
4. Run `./scripts/post_install.sh` to finalize
5. Build: `nh os switch`

### Adding a New Service

1. Create module: `modules/nixos/services/service-name/default.nix`
2. Add option to `modules/nixos/api/default.nix`
3. Configure in host's `default.nix`
4. Add DNS rewrite in AdGuard if needed

### Customizing Neovim

Edit files in `modules/home/nixvim/`:

- `opts.nix` - Editor options and colorscheme
- `keymaps.nix` - Key bindings
- `plugins/` - Plugin configurations

## 🤝 Contributing

This is a personal configuration, but feel free to:

- Open issues for questions
- Submit PRs for improvements
- Fork and adapt for your own use

## 📝 License

MIT License - Feel free to use and modify as needed.

## 🙏 Acknowledgments

- [NixOS](https://nixos.org/) - The foundation
- [Snowfall Lib](https://github.com/snowfallorg/lib) - Flake structure
- [NixVim](https://github.com/nix-community/nixvim) - Neovim configuration
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [COSMIC Desktop](https://github.com/pop-os/cosmic-epoch) - Modern desktop environment

---

**Built with ❤️ and Nix**
