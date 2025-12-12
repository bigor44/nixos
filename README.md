# Bigor's NixOS Configuration

A declarative, reproducible NixOS configuration managing two systems: a high-performance desktop workstation and a home lab server. Built with Flakes for modern dependency management and complete system reproducibility.

## Systems Overview

### grospc (Desktop Workstation)

- **Role**: Gaming & Development
- **Desktop Environment**: COSMIC (System76)
- **Kernel**: Linux Zen (optimized for desktop responsiveness)
- **CPU Governor**: Performance (maximum responsiveness)
- **Features**:
  - Full graphical environment with gaming optimizations
  - NFS client for accessing shared storage
  - Steam and GameMode integration
  - AMD P-State EPP for efficient power management

### minipc (Home Lab Server)

- **Role**: Infrastructure & Services
- **Mode**: Headless server
- **Kernel**: Standard Linux (stability focus)
- **CPU Governor**: Schedutil (power/performance balance)
- **Services**:
  - NFS server (centralized storage at `/mnt/storage`)
  - AdGuard Home (network-wide ad blocking and DNS)
  - Caddy (reverse proxy with automatic HTTPS)
  - Tailscale VPN (exit node with UDP GRO optimization)
  - SSH server (key-based authentication only)

## Project Structure

```
.
├── flake.nix                  # Main flake configuration
├── flake.lock                 # Dependency lock file
├── systems/
│   └── x86_64-linux/
│       ├── grospc/            # Desktop configuration
│       └── minipc/            # Server configuration
├── modules/
│   ├── nixos/
│   │   ├── core/              # Base system configuration
│   │   │   ├── nixvim/        # Neovim configuration
│   │   │   ├── options.nix    # Custom option definitions
│   │   │   ├── system.nix     # Nix settings & bootloader
│   │   │   ├── locale.nix     # Language & timezone
│   │   │   ├── users.nix      # User accounts
│   │   │   └── packages.nix   # System packages
│   │   ├── desktop/           # Desktop environment
│   │   │   ├── base.nix       # Audio, Bluetooth, browsers
│   │   │   ├── desktop-env.nix # COSMIC configuration
│   │   │   ├── fonts.nix      # Typography
│   │   │   └── gaming.nix     # Steam & GameMode
│   │   └── services/          # System services
│   │       ├── sshd.nix       # SSH daemon
│   │       ├── nfs.nix        # Network file sharing
│   │       ├── adguard.nix    # DNS & ad blocking
│   │       ├── caddy.nix      # Reverse proxy
│   │       └── tailscale.nix  # VPN mesh network
│   └── home/                  # Home Manager configuration
│       ├── packages.nix       # User applications
│       ├── shell.nix          # Fish shell setup
│       ├── git.nix            # Git configuration
│       └── dotfiles.nix       # Symlink management
├── dotfiles/                  # Application configurations
│   ├── cosmic/                # COSMIC desktop settings
│   └── autostart/             # Autostart applications
└── certs/                     # Internal CA certificates
```

## Key Features

### Modular Architecture

- **Role-based configuration**: `bigor.roles.desktop` and `bigor.roles.homelab_master` enable feature sets
- **Service flags**: `bigor.services.nfs.server`, `bigor.services.ssh.enable`, etc.
- **Clean separation**: Core, desktop, and service modules for maintainability

### Development Environment

- **Neovim (NixVim)**: Fully configured with LSP, Treesitter, Telescope, and modern plugins
- **Fish Shell**: Enhanced with Starship prompt, fzf, zoxide, and abbreviations
- **Code Quality**: Integrated formatters (alejandra, stylua, prettier, black, shfmt)

### Desktop Experience

- **COSMIC Desktop**: Modern, Rust-based desktop environment by System76
- **Audio**: Pipewire with ALSA, PulseAudio, and Wireplumber support
- **Fonts**: Comprehensive set including Nerd Fonts, Noto CJK, and emoji support
- **Gaming**: Steam with GameMode optimizations

### Server Infrastructure

- **AdGuard Home**: Network-wide DNS filtering with local domain rewrites
- **NFS**: Centralized storage accessible across the network
- **Caddy**: Automatic HTTPS for internal services via self-signed CA
- **Tailscale**: Secure mesh VPN with exit node capability

### Automation & Quality

- **Treefmt**: Unified code formatting across all file types
- **nh (Nix Helper)**: Simplified system rebuilds with automatic cleanup
- **Reproducible builds**: Flake-based dependency management

## Quick Start

### Prerequisites

- NixOS 25.11 installed
- Git for cloning the repository
- UEFI system (systemd-boot configuration)

### Installation

1. **Clone the repository**:

```bash
git clone https://github.com/yourusername/nixos-config.git ~/nixos
cd ~/nixos
```

2. **Review hardware configuration**:
   - Check `systems/x86_64-linux/{grospc,minipc}/hardware-configuration.nix`
   - Regenerate if needed: `nixos-generate-config --show-hardware-config`

3. **Build and switch** (for grospc):

```bash
sudo nixos-rebuild switch --flake .#grospc
```

Or for minipc:

```bash
sudo nixos-rebuild switch --flake .#minipc
```

### Using nh (recommended)

Once the system is built, use the integrated `nh` tool:

```bash
nh os switch  # Rebuilds and switches configuration
nh os boot    # Rebuilds and activates on next boot
nh os test    # Temporary activation (reverts on reboot)
```

## Development Workflow

### Entering the Dev Shell

```bash
nix develop
```

This provides:

- All formatters (alejandra, stylua, prettier, black, shfmt, taplo)
- nixd language server for editor integration

### Formatting Code

```bash
nix fmt  # Format all files according to treefmt.toml
```

### Running Checks

```bash
nix flake check  # Run all checks (formatting, linting, etc.)
```

### Updating Dependencies

```bash
nix flake update  # Update all inputs
nix flake update nixpkgs  # Update specific input
```

## Customization

### Adding a New Host

1. Create hardware configuration:

```bash
nixos-generate-config --show-hardware-config > systems/x86_64-linux/newhost/hardware-configuration.nix
```

2. Create host configuration:

```nix
# systems/x86_64-linux/newhost/default.nix
{...}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "newhost";
  system.stateVersion = "25.05";

  bigor = {
    roles.desktop = true;  # or homelab_master
    # ... other options
  };
}
```

3. Add to flake.nix:

```nix
nixosConfigurations.newhost = mkSystem { hostname = "newhost"; };
```

### Enabling Desktop on a New System

Simply set the role flag:

```nix
bigor.roles.desktop = true;
```

This automatically enables:

- COSMIC desktop environment
- Pipewire audio stack
- Fonts and typography
- Gaming setup (Steam, GameMode)
- GUI applications

### Enabling Server Services

```nix
bigor = {
  roles.homelab_master = true;
  services = {
    ssh.enable = true;
    nfs.server = true;
  };
};
```

## Network Configuration

### Static IPs

Default IPs are defined in `modules/nixos/core/options.nix`:

- grospc: `192.168.1.11`
- minipc: `192.168.1.10`

Override in host configuration:

```nix
bigor.network.ips.grospc = "192.168.1.20";
```

### NFS Setup

**Server** (minipc):

- Exports `/mnt/storage` to `192.168.1.0/24`
- Access controlled via `all_squash` to user `bigor` (UID 1000)

**Client** (grospc):

- Auto-mounts on access via systemd automount
- Mounted at `/mnt/storage`

### AdGuard Home

Access at: `https://adguard.bigor.lan` (requires internal CA cert trust)

Features:

- Network-wide ad blocking
- Local DNS with `.lan` domain support
- Domain rewrites for internal services
- DoH/DoT upstream resolvers (Cloudflare, Quad9, FDN)

### Tailscale VPN

minipc configured as exit node with UDP GRO optimization for maximum throughput.

## Neovim Configuration

### Features

- **LSP**: Bash, Markdown, Python, JSON, YAML, Lua, Nix
- **Formatting**: Auto-format on save via conform.nvim
- **Completion**: blink.cmp with LSP, path, buffer, and snippet sources
- **UI**: OneDark theme, mini.statusline, mini.notify, Telescope, Neo-tree
- **Git**: LazyGit integration, Gitsigns
- **Utilities**: Treesitter, Trouble, mini.surround, mini.pairs, mini.comment

### Key Bindings

- **Leader**: `Space`
- **Telescope**: `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers)
- **Explorer**: `<leader>e` (Neo-tree)
- **Git**: `<leader>gg` (LazyGit)
- **Diagnostics**: `<leader>xx` (Trouble), `<leader>d` (float), `[d`/`]d` (navigate)
- **LSP**: `gd` (definition), `K` (hover), `<leader>rn` (rename), `<leader>ca` (code action)

## Fish Shell

### Aliases

- `ll`, `la`, `lt`: Modern directory listings (eza)
- `..`, `...`, `....`: Quick directory navigation
- `rm`, `cp`, `mv`: Interactive prompts by default

### Abbreviations

- **Nix**: `nfc` (flake check), `nfu` (flake update)
- **Git**: `gaa` (add all), `gc` (commit), `gst` (status), `gp` (push), etc.
- **System**: `ports`, `meminfo`, `diskinfo`

### Integrated Tools

- **fzf**: Fuzzy finder with fd integration
- **zoxide**: Smart directory jumping (replaces cd)
- **bat**: Enhanced cat with syntax highlighting

## Maintenance

### Automatic Cleanup

Garbage collection runs automatically via `nh`:

- Keeps last 3 generations
- Removes items older than 4 days
- Optimizes store with hard links

### Manual Operations

```bash
# List generations
nix profile history --profile /nix/var/nix/profiles/system

# Delete old generations
sudo nix-collect-garbage --delete-older-than 7d

# Optimize store
nix store optimise
```

### Updating the System

```bash
cd ~/nixos
nix flake update
nh os switch
```

## Troubleshooting

### Boot Issues

- Boot menu shows up to 10 configurations (oldest auto-removed)
- Use arrow keys to select previous generation if needed
- Press `e` to edit boot parameters temporarily

### NFS Mount Failures

- Verify server is running: `systemctl status nfs-server`
- Check firewall: `sudo nix-shell -p nmap --run "nmap -p 111,2049 minipc"`
- Test mount manually: `sudo mount -t nfs minipc:/mnt/storage /mnt/test`

### Network Services Not Accessible

- Verify Caddy is running: `systemctl status caddy`
- Check DNS resolution: `dig adguard.bigor.lan`
- Trust internal CA: Add `certs/minipc-ca.pem` to browser/system

### Tailscale Connection Issues

- Verify service: `systemctl status tailscale`
- Check connection: `tailscale status`
- Test UDP GRO: `ethtool -k enp2s0 | grep gro`

## Contributing

This is a personal configuration, but suggestions are welcome via issues or pull requests.

### Code Style

All code is automatically formatted via treefmt:

- **Nix**: alejandra
- **Lua**: stylua
- **Shell**: shfmt
- **Python**: black + isort
- **Web formats**: prettier
- **TOML**: taplo

Run `nix fmt` before committing.

## License

This configuration is provided as-is for educational purposes. Feel free to use and modify as needed.

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixVim Documentation](https://nix-community.github.io/nixvim/)
- [Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [COSMIC Desktop](https://github.com/pop-os/cosmic-epoch)

---

**Current NixOS Version**: 25.11
**Last Updated**: December 2025
