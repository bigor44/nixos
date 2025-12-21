# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

```bash
# Build and switch system configuration (uses nh helper)
nh os switch              # Automatically detects hostname

# Build without switching
nh os build

# Check the flake (runs statix, deadnix, and formatting verification)
nix flake check

# Format all files
nix fmt

# Update flake inputs
nix flake update

# Clean old generations (keeps last 3 and anything from last 4 days)
nh clean all
```

## Architecture Overview

This is a NixOS + Home Manager configuration using **snowfall-lib** for an opinionated flake structure. The namespace for all custom options is `bigor.*`.

### Directory Structure

- `systems/x86_64-linux/<hostname>/` - Host-specific NixOS configurations
- `homes/x86_64-linux/<user>[@<host>]/` - Home Manager configurations (host-specific overrides use `user@host` format)
- `modules/nixos/` - NixOS modules (features, profiles, services)
- `modules/home/` - Home Manager modules (shell, git, nixvim, GUI, CLI)
- `checks/` - CI-style checks (statix, deadnix, formatting)
- `packages/` - Custom package definitions

### Configuration Hierarchy

**Profiles** (`bigor.profiles.*`) are high-level toggles that enable sets of features:

- `bigor.profiles.workstation` - Desktop: COSMIC DE, audio, fonts, gaming, node-exporter
- `bigor.profiles.homelab-master` - Server: SSH, Tailscale, AdGuard, Caddy, monitoring stack (Prometheus/Grafana/Alertmanager), Ollama, NFS

**Features** (`bigor.features.*`) are individual system capabilities toggled by profiles or directly.

**Services** (`bigor.services.*`) are declarative service modules (adguard, caddy, monitoring/\*, nfs, ollama, sshd, tailscale).

### Home Manager

Home modules are enabled via `bigor.home.*`:

- `bigor.home.shell` - Fish shell with Tide prompt, fzf, zoxide, bat
- `bigor.home.git` - Git configuration
- `bigor.home.cli-packages` - CLI tools
- `bigor.home.nixvim` - Full Neovim configuration (LSP, treesitter, completion)
- `bigor.home.features.gui` - GUI applications

### Hosts

- **grospc** - Desktop workstation (Zen kernel, gaming-optimized)
- **minipc** - Homelab server (standard kernel, runs all services)

### Network Topology (SSOT)

All network services and hosts are centrally defined in `modules/nixos/lib/network-topology/default.nix`. This is the Single Source of Truth for:

- **Hosts**: IP addresses and interfaces for all machines
- **Services**: All homelab services with their exposure settings (DNS, Caddy, firewall)

The consumer module (`modules/nixos/lib/network-consumer/`) automatically:

- Generates AdGuard DNS rewrites for ALL services (any host can run DNS)
- Configures Caddy reverse proxy for LOCAL services only
- Opens firewall ports for LOCAL services only

**Adding a new service:**

```nix
# In modules/nixos/lib/network-topology/default.nix
myservice = {
  host = "minipc";           # Which host runs it
  port = 8080;
  domain = "myservice.bigor.lan";
  expose = {
    dns = true;              # Create DNS rewrite
    reverseProxy = true;     # Expose via Caddy
    firewall = false;        # Caddy handles access
  };
};
```

**Adding a new host:**

```nix
# In modules/nixos/lib/network-topology/default.nix
newhost = {
  ip = "192.168.1.30";       # null for DHCP
  interface = "enp0s0";
};
```

## Key Patterns

- All custom options use the `bigor.*` namespace
- Modules use `mkEnableOption` and `mkDefault` for composability
- Profiles set defaults that can be overridden per-host
- Home Manager configs support host-specific overrides via `user@host` directories
- Secrets are managed with sops-nix (encrypted with age)
- Network topology is defined once in SSOT, consumed by all hosts
