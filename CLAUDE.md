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

### Network Topology (SSOT)

All network services and hosts are centrally defined in `modules/nixos/lib/network-topology/default.nix`. This is the Single Source of Truth for:

- **Hosts**: IP addresses and interfaces for all machines
- **Services**: All homelab services with their exposure settings (DNS, Caddy, firewall)

**Architecture:** Each module reads the topology directly:

- **Caddy** (`modules/nixos/services/caddy/`) - Generates reverse proxy config for LOCAL services only
- **Firewall** (`modules/nixos/features/system/network/`) - Opens ports for LOCAL services only
- **Blocky** (`modules/nixos/services/blocky/`) - Generates DNS rewrites for ALL services with domains

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
│  - Rewrites DNS locaux (auto SSOT)      │
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
    - `listenOnLan`: Listen on LAN interface (firewall auto-configured via topology)
  - Features: DNSSEC validation, prefetching, optimized cache (256MB)
  - Location: `modules/nixos/services/unbound/`

- **Blocky** (`bigor.services.blocky`): DNS proxy with ad/tracker blocking
  - Port: 53 (public DNS), 4000 (web/metrics)
  - Options:
    - `enable`: Enable Blocky
    - `upstreamMode`: "unbound-local" | "unbound-lan" | "external"
    - `upstreamHost`: Hostname for unbound-lan mode
    - `externalUpstreams`: List of external DNS servers for external mode
  - Features: Auto-generated rewrites from network-topology, multiple blocklists
  - Location: `modules/nixos/services/blocky/`
  - Prometheus metrics: `http://localhost:4000/metrics`

**DNS Rewrites (Auto-generated):**

DNS rewrites for local services are **automatically generated** from `network-topology`. The Blocky module reads the topology and creates rewrites for all services where:

- `domain != null`
- `expose.dns = true`
- Host has a static IP

**Example:** Adding a service to network-topology with `domain = "myapp.bigor.lan"` automatically creates the DNS rewrite in Blocky.

**Benefits:**

- ✅ Native DNSSEC validation (Unbound)
- ✅ Better performance (~60% faster than AdGuard Home)
- ✅ Modular: Can replace components independently
- ✅ Fully declarative: No web UI configuration needed
- ✅ Prometheus-ready: Built-in metrics for monitoring

## Key Patterns

- All custom options use the `bigor.*` namespace
- Modules use `mkEnableOption` and `mkDefault` for composability
- Profiles set defaults that can be overridden per-host
- Home Manager configs support host-specific overrides via `user@host` directories
- Secrets are managed with sops-nix (encrypted with age)
- Network topology is defined once in SSOT, consumed by all hosts
