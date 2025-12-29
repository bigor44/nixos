# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

```bash
# Build and switch system configuration (uses nh helper)
nh os switch              # Automatically detects hostname

# Build without switching
nh os build

# Run linters before flake check
statix check        # Check for anti-patterns
deadnix            # Check for dead code

# Format all files
nix fmt

# Check the flake (runs statix, deadnix, and formatting verification)
nix flake check

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

- `bigor.profiles.workstation` - Desktop: COSMIC DE, audio, fonts, gaming
- `bigor.profiles.homelab-master` - Server: SSH, DNS (Unbound+Blocky), Caddy, NFS

**Features** (`bigor.features.*`) are individual system capabilities toggled by profiles or directly.

**Services** (`bigor.services.*`) are declarative service modules (blocky, caddy, nfs, sshd, unbound).

### Home Manager

Home modules are enabled via `bigor.home.*`:

- `bigor.home.shell` - Fish shell with Tide prompt, fzf, zoxide, bat
- `bigor.home.git` - Git configuration
- `bigor.home.cli-packages` - CLI tools
- `bigor.home.nixvim` - Full Neovim configuration (LSP, treesitter, completion)
- `bigor.home.features.gui` - GUI applications

### Hosts

- **grospc** - Desktop workstation (Zen kernel, gaming-optimized, uses Blocky with automatic failover)
- **minipc** - Homelab server (standard kernel, runs Unbound + Blocky for the network)
- **minidesk** - Portable workstation (Zen kernel, uses Blocky with automatic failover, no NFS mounts)

### Service Configuration

Services are configured explicitly in their respective modules, with clear ownership of firewall rules and centralized DNS/reverse proxy configuration.

**Architecture:**

- **Network Hosts** (`bigor.network.hosts`): Centrally defined in `modules/nixos/features/system/network/` - defines all hosts with IPs and interfaces
- **Network Subnet** (`bigor.network.subnet`): Network subnet in CIDR notation (default: "192.168.1.0/24")
- **Caddy Virtual Hosts**: Explicitly defined in `modules/nixos/services/caddy/default.nix`
- **Blocky DNS Rewrites**: Auto-generated from `bigor.network.hosts` (all hosts get `<hostname>.bigor.lan`)
- **Firewall Rules**: Each service manages its own firewall configuration

**Adding a new service:**

1. **Create the service module** in `modules/nixos/services/myservice/default.nix`:

```nix
{ config, lib, ... }:
with lib;
let
  cfg = config.bigor.services.myservice;
  inherit (config.bigor.network) mainInterface;
in
{
  options.bigor.services.myservice.enable = mkEnableOption "My Service";

  config = mkIf cfg.enable {
    services.myservice = {
      enable = true;
      port = 8080;
    };

    # Self-managed firewall (if service needs external access)
    networking.firewall.interfaces.${mainInterface} = {
      allowedTCPPorts = [ 8080 ];
    };
  };
}
```

2. **Add virtual host** (if service needs reverse proxy) in `modules/nixos/services/caddy/default.nix`:

```nix
virtualHosts = {
  # ... existing entries ...
  "myservice.bigor.lan" = {
    extraConfig = ''
      reverse_proxy http://127.0.0.1:8080
      tls internal
    '';
  };
};
```

**Adding a new host:**

```nix
# In modules/nixos/features/system/network/default.nix
config.bigor.network.hosts = {
  newhost = {
    ip = "192.168.1.50";       # null for DHCP
    interface = "enp0s0";
  };
};
```

### DNS Stack (Unbound + Blocky)

The homelab uses a **resilient DNS architecture** with automatic failover:

- **All hosts** run Blocky locally for ad blocking and caching
- **minipc** runs Unbound (DNSSEC resolver) and serves it to the network
- **Other hosts** use minipc's Unbound with automatic fallback to Cloudflare

#### **Architecture**

```
┌─────────────────────────────────────────┐
│     CLIENT HOSTS (grospc, minidesk)     │
│           BLOCKY (Port 53)              │
│   - Ad/tracker blocking                 │
│   - Local DNS cache                     │
│   - Auto-generated DNS rewrites         │
└────────────────┬────────────────────────┘
                 │
                 ├─ Primary: minipc:5335 (Unbound w/ DNSSEC)
                 └─ Fallback: 1.1.1.1, 1.0.0.1 (Cloudflare)

┌─────────────────────────────────────────┐
│           minipc (DNS Server)           │
│           BLOCKY (Port 53)              │
│   - Ad/tracker blocking                 │
│   - Local DNS cache                     │
└────────────────┬────────────────────────┘
                 │
                 ▼
         UNBOUND (Port 5335)
         - DNSSEC validation
         - Recursive resolution
         - Optimized cache (256MB)
         - Accessible from LAN
```

#### **Configuration**

**DNS Server (minipc):**

```nix
# In homelab-master profile (automatic)
bigor.services.unbound = {
  enable = true;
  listenOnLan = true;  # Serve Unbound to LAN
};
bigor.services.blocky = {
  enable = true;
  useLocalUnbound = true;  # Use local Unbound
};
```

**Client Hosts (grospc, minidesk):**

```nix
# Blocky automatically uses minipc:5335 with Cloudflare fallback
bigor.services.blocky.enable = true;
```

#### **Modules**

- **Unbound** (`bigor.services.unbound`): High-performance recursive DNS resolver with DNSSEC
  - Port: 5335
  - Options:
    - `enable`: Enable Unbound
    - `listenOnLan`: Listen on LAN interface (firewall auto-opened)
  - Features: DNSSEC validation, prefetching, optimized cache (256MB)
  - Location: `modules/nixos/services/unbound/`

- **Blocky** (`bigor.services.blocky`): DNS proxy with ad/tracker blocking and automatic failover
  - Port: 53 (DNS), 4000 (metrics)
  - Options:
    - `enable`: Enable Blocky
    - `useLocalUnbound`: Use local Unbound (127.0.0.1:5335) instead of minipc
    - `fallbackUpstreams`: Fallback DNS servers (default: `["1.1.1.1" "1.0.0.1"]`)
    - `upstreamTimeout`: Timeout before failover (default: `"2s"`)
  - Features: Auto-generated DNS rewrites from `bigor.network.hosts`, automatic failover
  - Location: `modules/nixos/services/blocky/`

**DNS Rewrites (Auto-generated):**

DNS rewrites are automatically generated from `bigor.network.hosts`:

```nix
# Automatically creates:
# minipc.bigor.lan → 192.168.1.10
# grospc.bigor.lan → 192.168.1.11
# minidesk.bigor.lan → <DHCP, filtered>
# bigor.lan → 192.168.1.10 (alias to minipc)
```

**Failover Behavior:**

- **Strategy**: Strict (try in order with 2s timeout)
- **Primary**: minipc Unbound (DNSSEC + privacy)
- **Fallback**: Cloudflare (1.1.1.1, 1.0.0.1) if minipc unreachable
- **Use case**: Travel mode (minidesk) or minipc offline

**Benefits:**

- ✅ Native DNSSEC validation (Unbound)
- ✅ Automatic failover for resilience
- ✅ Ad blocking on every host (works offline)
- ✅ Zero-configuration DNS rewrites
- ✅ Fully declarative configuration

## Key Patterns

- All custom options use the `bigor.*` namespace
- Services self-manage their firewall rules
- Modules use `mkEnableOption` and `mkDefault` for composability
- Profiles set defaults that can be overridden per-host
- Home Manager configs support host-specific overrides via `user@host` directories
- Network hosts centrally defined in `bigor.network.hosts`
- Virtual hosts explicitly configured in Caddy module
- DNS rewrites explicitly configured in Blocky module
- Firewall uses nftables (modern successor to iptables) for better performance and IPv6 support
