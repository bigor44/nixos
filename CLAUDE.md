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

# Test DNS stack (Blocky + Unbound)
nix run .#dns-stack-validator  # Run on systems with DNS stack enabled
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

### Service Configuration

Services are configured explicitly in their respective modules, with clear ownership of firewall rules and centralized DNS/reverse proxy configuration.

**Architecture:**

- **Network Hosts** (`bigor.network.hosts`): Centrally defined in `modules/nixos/features/system/network/` - defines all hosts with IPs, interfaces, and node-exporter tracking
- **Network Subnet** (`bigor.network.subnet`): Network subnet in CIDR notation (default: "192.168.1.0/24")
- **Caddy Virtual Hosts**: Explicitly defined in `modules/nixos/services/caddy/default.nix`
- **Blocky DNS Rewrites**: Explicitly defined in `modules/nixos/services/blocky/default.nix`
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

2. **Add DNS rewrite** (if service has a domain) in `modules/nixos/services/blocky/default.nix`:

```nix
customDNSMapping = lib.filterAttrs (_: ip: ip != null) {
  # ... existing entries ...
  "myservice.bigor.lan" = config.bigor.network.hosts.minipc.ip;
};
```

3. **Add virtual host** (if service needs reverse proxy) in `modules/nixos/services/caddy/default.nix`:

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
    ip = "192.168.1.30";       # null for DHCP
    interface = "enp0s0";
    hasNodeExporter = true;    # Enable for Prometheus monitoring
  };
};
```

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
    - `listenOnLan`: Listen on LAN interface (firewall automatically opened when enabled)
  - Features: DNSSEC validation, prefetching, optimized cache (256MB)
  - Location: `modules/nixos/services/unbound/`

- **Blocky** (`bigor.services.blocky`): DNS proxy with ad/tracker blocking
  - Port: 53 (DNS), 4000 (metrics)
  - Options:
    - `enable`: Enable Blocky
    - `upstreamMode`: "unbound-local" | "unbound-lan" | "external"
    - `upstreamHost`: Hostname for unbound-lan mode
    - `externalUpstreams`: List of external DNS servers for external mode
  - Features: Explicit DNS rewrites, multiple blocklists
  - Location: `modules/nixos/services/blocky/`
  - Prometheus metrics: `http://localhost:4000/metrics`

**DNS Rewrites (Explicit):**

DNS rewrites are explicitly configured in `modules/nixos/services/blocky/default.nix`:

```nix
customDNSMapping = lib.filterAttrs (_: ip: ip != null) {
  # Service domains
  "prometheus.bigor.lan" = config.bigor.network.hosts.minipc.ip;
  "grafana.bigor.lan" = config.bigor.network.hosts.minipc.ip;
  # DNS-only entries
  "minipc.bigor.lan" = config.bigor.network.hosts.minipc.ip;
  "grospc.bigor.lan" = config.bigor.network.hosts.grospc.ip;
  "bigor.lan" = config.bigor.network.hosts.minipc.ip;
};
```

**Startup Dependencies:**

Blocky includes a robust health check script that ensures Unbound is fully operational before starting:

- **Active polling**: Checks Unbound availability every 0.5s (max 30s timeout)
- **TCP connection test**: Verifies port 5335 is accepting connections
- **DNS resolution test**: Validates that Unbound can resolve queries
- **DNSSEC validation test**: Confirms DNSSEC is active using `sigok.verteiltesysteme.net`
- **Precise timing**: Reports actual elapsed time (e.g., "1.5s", "2.0s")

This eliminates race conditions and ensures DNS stack reliability.

**Testing the DNS Stack:**

The `dns-stack-validator` package provides comprehensive validation:

```bash
nix run .#dns-stack-validator
```

**Tests performed:**

- ✅ Service status (systemd)
- ✅ Port availability (53, 5335)
- ✅ Startup dependency logs
- ✅ Unbound DNS resolution
- ✅ DNSSEC validation (positive: sigok.verteiltesysteme.net, negative: sigfail.verteiltesysteme.net)
- ✅ Blocky local DNS rewrites (.bigor.lan domains)
- ✅ Forwarding from Blocky to Unbound
- ✅ Ad blocking functionality
- ✅ Prometheus metrics endpoint
- ✅ System DNS configuration

**Benefits:**

- ✅ Native DNSSEC validation (Unbound)
- ✅ High performance with optimized caching
- ✅ Modular: Can replace components independently
- ✅ Fully declarative: No web UI configuration needed
- ✅ Prometheus-ready: Built-in metrics for monitoring
- ✅ Robust startup: Health checks ensure service reliability
- ✅ Comprehensive testing: Automated validation tool included

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
