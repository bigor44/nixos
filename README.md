# NixOS Configuration

A modular, policy-driven NixOS configuration managing a homelab server and desktop workstations using Flakes, Home Manager, and a custom module system.

## Features

- **Policy-Based Architecture**: Strategic decisions (kernel, DNS, power, storage) defined once and enforced across hosts
- **Modular Design**: Clean separation between features, services, policies, and profiles under the `bigor.*` namespace
- **Multi-Host Management**: Unified configuration for homelab server (minipc), gaming workstation (grospc), and portable laptop (minidesk)
- **Centralized Network Topology**: All IPs, interfaces, and ports defined in a single source of truth
- **Integrated QA Tooling**: Fast incremental checks, pre-commit hooks, and CI-equivalent validation
- **Declarative Secrets**: SOPS-nix with age encryption for secure credential management
- **Modern Desktop**: COSMIC DE with Wayland, custom keybindings, and dotfile management
- **Development Environment**: Pre-configured nixvim, zsh with plugins, and developer tools

## Repository Structure

```
.
├── flake.nix                    # Main entry point
├── nix/
│   ├── hosts.nix               # NixOS configurations for all hosts
│   ├── modules.nix             # Module registry (import list)
│   ├── checks.nix              # Automated quality checks
│   └── devshell.nix            # Development environment
├── hosts/
│   ├── minipc/                 # Homelab server (AMD, NFS, DNS, Caddy)
│   ├── grospc/                 # Gaming workstation (AMD, Zen kernel)
│   └── minidesk/               # Portable laptop (DHCP)
├── modules/
│   ├── nixos/
│   │   ├── features/           # Optional capabilities (audio, desktop, gaming...)
│   │   ├── policies/           # Strategic decisions (kernel, DNS, power, storage)
│   │   ├── services/           # Network services (blocky, caddy, nfs, unbound)
│   │   └── profiles/           # Composite configs (workstation, homelab-master)
│   └── home/
│       └── features/           # Home Manager modules (CLI, GUI, dev-scripts)
├── users/
│   └── bigor/                  # User-specific configuration
├── dotfiles/                   # Symlinked configuration files
└── secrets/                    # SOPS-encrypted secrets
```

## Hosts

### minipc (Homelab Server)

- **Role**: Network infrastructure and storage server
- **Kernel**: LTS (server policy)
- **DNS**: Unbound + Blocky (recursive resolver with ad-blocking)
- **Services**: Caddy reverse proxy, NFS server
- **Network**: Static IP 192.168.1.10

### grospc (Gaming Workstation)

- **Role**: Primary desktop for work and gaming
- **Kernel**: Zen (desktop policy, optimized for responsiveness)
- **Desktop**: COSMIC DE with Wayland
- **Features**: Audio, gaming, Flatpak, VIA keyboard configurator
- **Network**: Static IP 192.168.1.11

### minidesk (Portable Laptop)

- **Role**: Mobile workstation
- **DNS**: Portable mode (cloud upstreams, no LAN dependency)
- **Desktop**: COSMIC DE with Wayland
- **Network**: DHCP

## Key Architectural Concepts

### Policy System

Policies centralize strategic decisions to eliminate duplication across hosts. Instead of repeating kernel selection or DNS configuration in every host, policies define the strategy once:

```nix
# In host configuration
bigor.policies = {
  kernel = "desktop";              # Automatically selects Zen kernel
  dns.mode = "lan-recursive";      # Use minipc as DNS server
  power = "amd-pstate";            # AMD CPU power management
  storage.mode = "nfs-client";     # Mount NFS shares from minipc
};
```

Policies provide computed read-only values that services consume:

```nix
# Services automatically adapt to policy decisions
config.bigor.policies.dns.computed.blockyUpstreams
# Returns: ["192.168.1.10:5335", "1.1.1.1", "9.9.9.9"] in lan-recursive mode
```

### Network Topology

All network configuration is centralized in `modules/nixos/features/system/network.nix`:

```nix
bigor.network.hosts.minipc.ip        # "192.168.1.10"
bigor.network.ports.blocky.dns       # 53
bigor.network.subnet                 # "192.168.1.0/24"
```

Services reference the topology instead of hardcoding values, making the configuration self-documenting and easy to maintain.

### Module Namespaces

All custom options use the `bigor.*` namespace with clear categories:

- `bigor.features.*` - Optional capabilities (audio, desktop, gaming)
- `bigor.policies.*` - Strategic decisions (kernel, DNS, power)
- `bigor.services.*` - Network services (blocky, caddy, nfs)
- `bigor.profiles.*` - Composite configurations (workstation, homelab-master)
- `bigor.home.features.*` - Home Manager modules (CLI, GUI, shell)

## Quick Start

### Prerequisites

- NixOS 25.11 or later with flakes enabled
- For secrets: age key in `~/.config/sops/age/keys.txt`
- For development: [nh](https://github.com/viperML/nh) (NixOS Helper)

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/bigor44/nixos.git ~/nixos
   cd ~/nixos
   ```

2. **Create your host configuration**:

   ```bash
   mkdir -p hosts/myhost
   nixos-generate-config --show-hardware-config > hosts/myhost/hardware-configuration.nix
   ```

   Create `hosts/myhost/default.nix`:

   ```nix
   { ... }:
   {
     imports = [ ./hardware-configuration.nix ];

     networking.hostName = "myhost";
     system.stateVersion = "25.11";

     bigor = {
       policies = {
         kernel = "desktop";
         dns.mode = "portable";
       };
       profiles.workstation.enable = true;
     };
   }
   ```

   Create `hosts/myhost/home.nix`:

   ```nix
   { ... }:
   {
     home.stateVersion = "25.11";

     bigor.home.features = {
       gui.enable = true;
       dev-scripts.enable = true;
     };
   }
   ```

3. **Add host to network topology**:

   Edit `modules/nixos/features/system/network.nix`:

   ```nix
   bigor.network.hosts.myhost = {
     ip = null;  # or "192.168.1.XX" for static IP
     interface = "eth0";
   };
   ```

4. **Register the host**:

   Edit `nix/hosts.nix`:

   ```nix
   flake.nixosConfigurations = {
     # ... existing hosts
     myhost = mkHost "myhost";
   };
   ```

5. **Build and test**:

   ```bash
   # Build without applying
   nix build .#nixosConfigurations.myhost.config.system.build.toplevel

   # Or use nh for better UX
   nh os build --hostname myhost
   ```

6. **Apply configuration**:

   ```bash
   sudo nixos-rebuild switch --flake .#myhost
   # or
   nh os switch --hostname myhost
   ```

## Development Workflow

### Quality Checks (Required Before Committing)

```bash
# 1. Format code
nix fmt

# 2. Check for dead code
deadnix --fail .

# 3. Lint for anti-patterns
statix check --ignore .* .

# 4. Run all checks (formatting, linting, policy assertions)
nix flake check
```

### Development Shell

Enter the development shell for access to QA tools and workflow shortcuts:

```bash
nix develop
```

Available commands:

- `qc` or `check-quick` - Fast incremental check (changed files only, <0.1s)
- `qf` or `check-full` - Complete CI-equivalent check (~16s)
- `mega` or `check-mega` - Intelligent check (adapts to git state)
- `gcn` - Add + format + check + commit workflow
- `gps` - Full check + push workflow

See [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed development guidelines.

## Customization

### Using This Configuration

This repository is designed to be forked and customized. Here are common customization points:

1. **Replace the namespace**: Search and replace `bigor` with your preferred namespace
2. **Remove unused hosts**: Delete host directories and remove from `nix/hosts.nix`
3. **Adjust network topology**: Update IPs and interfaces in `modules/nixos/features/system/network.nix`
4. **Configure policies**: Set kernel, DNS, power, and storage strategies per host
5. **Enable/disable features**: Toggle audio, gaming, flatpak, etc. as needed
6. **Customize secrets**: Replace `.sops.yaml` with your age keys

### Learning Resources

If you're new to NixOS or want to understand the patterns used here:

- **Module pattern**: See `CLAUDE.md` for detailed module templates
- **Policy system**: Read `modules/nixos/policies/` for examples
- **Network topology**: Study `modules/nixos/features/system/network.nix`
- **Quality tooling**: Explore `modules/home/features/dev-scripts.nix`

## Project Goals

This configuration prioritizes:

1. **Maintainability**: Clear module boundaries, explicit imports, no `with lib;`
2. **Composability**: Mix and match features, policies, and profiles
3. **Type Safety**: Leverages Nix type system with assertions and validation
4. **Documentation**: Self-documenting through centralized topology and policies
5. **Quality**: Automated formatting, linting, and dead code detection

## Technology Stack

- **NixOS**: Declarative Linux distribution
- **Nix Flakes**: Reproducible dependency management
- **flake-parts**: Modular flake organization
- **Home Manager**: Declarative user environment management
- **nixvim**: Neovim configured in Nix
- **SOPS-nix**: Secret management with age encryption
- **COSMIC DE**: System76's Rust-based desktop environment
- **Quality Tools**: nixfmt, statix, deadnix, treefmt

## Contributing

Contributions, suggestions, and questions are welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for:

- Development workflow
- Module patterns
- Code style guidelines
- Testing procedures
- Commit message conventions

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Acknowledgments

- [NixOS](https://nixos.org/) community for the amazing ecosystem
- [flake-parts](https://flake.parts/) for modular flake organization
- [Home Manager](https://github.com/nix-community/home-manager) for user environment management
- [nixvim](https://github.com/nix-community/nixvim) for Neovim configuration
- [SOPS-nix](https://github.com/Mic92/sops-nix) for secrets management
- [COSMIC DE](https://github.com/pop-os/cosmic-epoch) by System76

## Contact

- GitHub: [@bigor44](https://github.com/bigor44)
- Repository: [github.com/bigor44/nixos](https://github.com/bigor44/nixos)

---

**Note**: This is a personal configuration shared for educational purposes. Secrets are encrypted with SOPS and hardware-specific settings are isolated in `hardware-configuration.nix`. Feel free to use this as inspiration for your own NixOS setup!
