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
- `bigor.profiles.homelab-master` - Server: SSH, Tailscale, DNS (Unbound+Blocky), Caddy, monitoring stack (Prometheus/Grafana/Alertmanager), Ollama, NFS

**Features** (`bigor.features.*`) are individual system capabilities toggled by profiles or directly.

**Services** (`bigor.services.*`) are declarative service modules (blocky, caddy, monitoring/\*, nfs, ollama, sshd, tailscale, unbound).

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
- **minidesk** - Portable workstation (Zen kernel, travel mode with Blocky standalone, no NFS mounts)

### Service Registry Pattern

Services automatically register themselves when enabled, creating a distributed configuration model. The registry is consumed by Caddy, Blocky, and the firewall.

**Architecture:**

- **Service Registry** (`bigor.registry.services.*`): Services self-register when enabled
- **Host Registry** (`bigor.network.hosts`): Centrally defined in `modules/nixos/features/system/network/`
- **Network Subnet** (`bigor.network.subnet`): Network subnet in CIDR notation (default: "192.168.1.0/24")
- **DNS-Only Entries** (`bigor.network.dnsEntries`): For hosts without services (e.g., minipc.bigor.lan)

**Consumers:**

- **Caddy** (`modules/nixos/services/caddy/`) - Generates reverse proxy config from services with `reverseProxy = true` on LOCAL host
- **Blocky** (`modules/nixos/services/blocky/`) - Generates DNS rewrites from ALL services with domains + dnsEntries
- **Firewall** (`modules/nixos/features/system/network/`) - Opens ports for LOCAL services with `openFirewall = true` or `openFirewallUDP = true` on the main interface (uses nftables)

**Adding a new service:**

Services self-register in their module:

```nix
# In the service module (e.g., modules/nixos/services/myservice/default.nix)
config = mkIf cfg.enable {
  # Register in registry
  bigor.registry.services.myservice = {
    hostName = config.networking.hostName;
    port = 8080;
    domain = "myservice.bigor.lan";
    reverseProxy = true;              # Expose via Caddy
    openFirewall = false;             # Direct firewall access
    openFirewallUDP = false;          # UDP firewall access
    proxyProtocol = "http";           # http or https
  };

  # Configure actual service
  services.myservice = { ... };
};
```

Then enable it in profile or host config:

```nix
bigor.services.myservice.enable = true;
```

The service will automatically:

- Get a DNS entry (via Blocky)
- Get reverse proxy (via Caddy) if `reverseProxy = true`
- Get firewall port opened if `openFirewall = true`

**Adding a new host:**

```nix
# In modules/nixos/features/system/network/default.nix
config.bigor.network.hosts = {
  newhost = {
    ip = "192.168.1.30";       # null for DHCP
    interface = "enp0s0";
  };
};
```

**Validations:**

The registry validates at build time:

- Domain uniqueness across all services and DNS entries
- Port range (0-65535)
- Host existence in `bigor.network.hosts`

### DNS Stack (Unbound + Blocky)

The homelab uses a **modular DNS architecture** for better performance and separation of concerns. Both Blocky and Unbound can be configured independently and support multiple deployment patterns.

#### **Deployment Patterns**

**1. Full Stack (minipc)** - Blocky + Unbound local:

```nix
bigor.services.blocky = {
  enable = true;
  upstreamMode = "unbound-local";  # Default
};
bigor.services.unbound = {
  enable = true;
  listenOnLan = true;  # Allow other hosts to use this Unbound
};
```

**2. Blocky with Remote Unbound (grospc)** - Blocky forwards to Unbound on LAN:

```nix
bigor.services.blocky = {
  enable = true;
  upstreamMode = "unbound-lan";
  upstreamHost = "minipc";  # Use minipc's Unbound
};
```

**3. Blocky Standalone (minidesk)** - Blocky with external upstreams:

```nix
bigor.services.blocky = {
  enable = true;
  upstreamMode = "external";
  externalUpstreams = [ "1.1.1.1" "1.0.0.1" ];  # Cloudflare (default)
};
```

#### **Architecture (Full Stack)**

```
┌─────────────────────────────────────────┐
│         CLIENTS (devices)               │
└────────────────┬────────────────────────┘
                 │ DNS Query (port 53)
                 ↓
┌─────────────────────────────────────────┐
│         BLOCKY (Port 53)                │
│  - Filtrage/blocage ads/trackers        │
│  - Rewrites DNS locaux (auto registry)  │
│  - Upstream → Unbound or external       │
│  - Metrics: http://localhost:4000       │
└────────────────┬────────────────────────┘
                 │ Query non-bloquée
                 ↓
┌─────────────────────────────────────────┐
│         UNBOUND (Port 5335)             │
│  - Résolution récursive                 │
│  - DNSSEC validation                    │
│  - Cache optimisé                       │
│  - Localhost + LAN (optional)           │
└─────────────────────────────────────────┘
```

#### **Modules**

- **Unbound** (`bigor.services.unbound`): High-performance recursive DNS resolver with DNSSEC
  - Port: 5335
  - Options:
    - `enable`: Enable Unbound
    - `listenOnLan`: Listen on LAN interface (firewall auto-configured via registry)
  - Features: DNSSEC validation, prefetching, optimized cache (256MB)
  - Location: `modules/nixos/services/unbound/`

- **Blocky** (`bigor.services.blocky`): DNS proxy with ad/tracker blocking
  - Port: 53 (DNS), 4000 (metrics)
  - Options:
    - `enable`: Enable Blocky
    - `upstreamMode`: "unbound-local" | "unbound-lan" | "external"
    - `upstreamHost`: Hostname for unbound-lan mode
    - `externalUpstreams`: List of external DNS servers for external mode
  - Features: Auto-generated rewrites from registry + dnsEntries, multiple blocklists
  - Location: `modules/nixos/services/blocky/`
  - Prometheus metrics: `http://localhost:4000/metrics`

**DNS Rewrites (Auto-generated):**

DNS rewrites are automatically generated from two sources:

1. **Services in the registry** with `domain != null` and host has static IP
2. **DNS-only entries** in `bigor.network.dnsEntries`

**Example:** Enabling a service with `domain = "myapp.bigor.lan"` automatically creates the DNS rewrite in Blocky.

**Benefits:**

- ✅ Native DNSSEC validation (Unbound)
- ✅ High performance with optimized caching
- ✅ Modular: Can replace components independently
- ✅ Fully declarative: No web UI configuration needed
- ✅ Prometheus-ready: Built-in metrics for monitoring

## Key Patterns

- All custom options use the `bigor.*` namespace
- Services self-register in `bigor.registry.services` when enabled
- Modules use `mkEnableOption` and `mkDefault` for composability
- Profiles set defaults that can be overridden per-host
- Home Manager configs support host-specific overrides via `user@host` directories
- Secrets are managed with sops-nix (encrypted with age)
- Network hosts centrally defined in `bigor.network.hosts`
- Service exposure (Caddy, DNS, firewall) auto-configured from registry
- Firewall uses nftables (modern successor to iptables) for better performance and IPv6 support
