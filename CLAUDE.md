# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

### Quality Assurance

```bash
# Fast incremental check during development (<0.1s)
check-quick  # or qc

# Complete CI-equivalent check before commits (~16s)
check-full   # or qf

# Intelligent check (adapts to git state)
check-mega   # or mega

# Format all Nix files
nix fmt

# DNS functional test (after DNS changes)
dns-test

# Linting
statix check .
deadnix --fail .
```

### Safe Workflow Aliases

```bash
# Format + add all + check staged + commit
gcn -m "commit message"

# Full check + push
gps

# Full check + rebuild switch (recommended for applying changes)
nrs

# Full check + rebuild boot
nrb
```

### Building Specific Hosts

```bash
# Build configuration for a specific host
nix build .#nixosConfigurations.grospc.config.system.build.toplevel
nix build .#nixosConfigurations.minipc.config.system.build.toplevel
nix build .#nixosConfigurations.minidesk.config.system.build.toplevel

# Check flake structure
nix flake check
nix flake show
```

### Development Environment

```bash
# Enter development shell (auto-installs tools and hooks)
nix develop
```

## Architecture

### Core Principles

**Platform vs Features Pattern**: The codebase uses a strict separation between mandatory infrastructure and optional functionality.

- **Platform modules** (`modules/nixos/platform/`): Always-active infrastructure that every host needs (boot, network, users, fonts, localization, packages, SOPS, DNS). These modules do NOT have `enable` options.

- **Feature modules** (`modules/nixos/features/`): Optional functionality gated by `bigor.features.<name>.enable` options. Each feature module must follow the standard template with `mkEnableOption` and `mkIf cfg.enable` wrapping.

- **Policy modules** (`modules/nixos/platform/policies/`): Strategic decisions that affect system behavior across hosts. Currently one policy:
  - Storage policy (`storage.nix`): Controls storage configuration (nfs-server, nfs-client, local, none)

### Network Topology

All network configuration is centralized in `nix/network-topology.nix`. This file contains:

- Subnet and domain definitions
- Host IP addresses and network interfaces
- Service port numbers (blocky, caddy, nfs, gatus)

When adding new services that need static IPs or ports, update this file. The network topology is injected into all hosts via `specialArgs` in `nix/hosts.nix`.

### Firewall Management

Firewall configuration is **fully centralized** in `modules/nixos/platform/firewall.nix`. This platform module:

- **Automatically opens required ports** based on enabled features and network topology
- **Validates static IP requirements** for services that listen on LAN
- **Adapts to DNS role** (opens port 53 only in server mode)
- **Uses network-topology.nix** as single source of truth for port numbers

**Port opening logic:**

- **blocky**: Port 53 (TCP/UDP) only when DNS mode is `server`
- **caddy**: Ports 80, 443 (TCP) when enabled
- **nfs-server**: Ports 111, 2049 (TCP/UDP) when enabled

**Static IP assertions:**

Services requiring a static IP (serving LAN) will trigger an assertion failure if the host has no static IP configured:

- DNS server (Blocky in server mode)
- caddy (reverse proxy)
- nfs-server (file sharing)

**IMPORTANT: Feature modules must NOT contain firewall configuration.** All firewall rules are managed by the central platform module.

### Module Registration

All custom modules must be explicitly registered in `nix/modules.nix`:

- Add NixOS modules to the `nixosModules` list
- Add Home Manager modules to the `homeModules` list

This file is the single source of truth for what modules are loaded across all hosts.

### Host Configuration Pattern

Host configurations (`hosts/*/default.nix`) follow this structure:

```nix
{
  networking.hostName = "hostname";
  system.stateVersion = "25.11";
  boot.kernelPackages = pkgs.linuxPackages_zen;  # or _lts

  bigor = {
    platform = {
      dns.mode = "client";             # or server, standalone
      policies.storage.mode = "nfs-client"; # or nfs-server, local, none
    };

    features = {
      desktop.enable = true;
      audio.enable = true;
      # ... other optional features
    };
  };
}
```

### Policy System Details

**DNS Platform Architecture** (`modules/nixos/platform/dns/`):

DNS is a mandatory platform service. Every system runs **Blocky** locally as a unified interface for DNS resolution and ad-blocking.

**DNS Modes**:

- `server`: Host serves DNS to the LAN.
  - Upstream: DoH (Cloudflare/Quad9)
  - Open ports: 53 (LAN)
  - Requirements: Static IP
- `client`: Host uses the LAN DNS server (minipc).
  - Upstream: LAN Server IP
  - Benefits: Shared cache, local domain resolution
- `standalone`: Host is independent (laptop/roaming).
  - Upstream: DoH (Cloudflare/Quad9)
  - Benefits: Works everywhere, no LAN dependency

**Implementation**: All DNS logic is consolidated in `modules/nixos/platform/dns/default.nix`. Blocky is the sole driver.

**Why Blocky only?**

- **Unified DNS interface**: Single codebase, consistent behavior across all hosts
- **Built-in capabilities**: DoH/DoT support, ad-blocking, custom DNS, caching
- **Simplicity**: One service to configure, monitor, and debug
- **Portability**: Works identically in server, client, and standalone modes
- **Trade-off**: No local DNSSEC validation (delegated to upstream DoH providers like Cloudflare and Quad9)

This architectural choice replaces the previous dual-stack (Unbound + Blocky) with a single, application-layer DNS proxy. DNSSEC validation is handled by upstream recursive resolvers, which is acceptable for this use case.

**Storage Policy** (`modules/nixos/platform/policies/storage.nix`):

- `nfs-server`: Exports `/mnt/storage` via NFS (requires static IP + device)
- `nfs-client`: Mounts from minipc via NFS
- `local`: Local storage mount (requires device)
- `none`: No storage configuration

The policy automatically enables `bigor.features.nfs-server` or `bigor.features.nfs-client` based on mode and validates prerequisites.

### Flake Structure

The flake uses `flake-parts` for modularity:

- `nix/hosts.nix`: Defines all NixOS configurations via `mkHost` helper
- `nix/checks.nix`: Quality assurance checks
- `nix/devshell.nix`: Development shell configuration
- `nix/modules.nix`: Module registration
- `nix/network-topology.nix`: Network data

All hosts share common modules (platform + features + Home Manager) and receive `networkTopology` via `specialArgs`.

### Home Manager Integration

Home Manager is configured at the system level in `nix/hosts.nix`. Each user gets:

- Common home modules from `nix/modules.nix`
- User-specific config from `users/bigor/`
- Host-specific home config from `hosts/*/home.nix`

## File Header Standards

Every Nix file must start with a 2-line header:

```nix
# Feature: name
# Purpose: Brief description
```

Use these prefixes:

- `# Platform:` for modules in `modules/nixos/platform/`
- `# Feature:` for modules in `modules/nixos/features/`
- `# Module:` for shared Home Manager modules in `modules/home/`
- `# Home:` for user-specific or NixVim components
- `# Host:` for `hosts/*/default.nix`
- `# Policy:` for `modules/nixos/platform/policies/`
- `# Flake:` for flake-parts modules in `nix/`

## Creating New Feature Modules

When adding a new feature module in `modules/nixos/features/`:

1. Follow the standard template (see `modules/nixos/features/gaming.nix` as reference):

```nix
# Feature: name
# Purpose: Brief description
{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.name;
in
{
  options.bigor.features.name.enable = mkEnableOption "Description";

  config = mkIf cfg.enable {
    # Configuration here
  };
}
```

2. Register the module in `nix/modules.nix` under `nixosModules`
3. Enable it in host configurations via `bigor.features.name.enable = true`

Platform modules do NOT follow this pattern - they are always active and don't have enable options.

### Code Style: `inherit` Pattern

**Rule:** Only use `inherit (lib)` when you have **3 or more** usages of lib functions.

**Why:** The `inherit` pattern reduces verbosity but adds cognitive overhead. For 1-2 usages, prefixing with `lib.` is clearer and more direct.

**Examples:**

Good (3+ usages):

```nix
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.bigor.features.name;
in
```

Bad (only 2 usages - over-engineering):

```nix
let
  inherit (lib) mkEnableOption mkIf;  # Only 2 usages
  cfg = config.bigor.home.name;
in
```

Better (direct usage):

```nix
let
  cfg = config.bigor.home.name;
in
{
  options.bigor.home.name.enable = lib.mkEnableOption "...";
  config = lib.mkIf cfg.enable { ... };
}
```

## Secret Management

Secrets are managed with SOPS + age:

```bash
# Edit encrypted secrets
sops secrets/secrets.yaml

# View decrypted secrets (read-only)
sops -d secrets/secrets.yaml
```

Never commit plain-text secrets. Reference secrets in modules via `config.sops.secrets.<name>`.

## Host Overview

- **grospc**: Desktop workstation (Zen kernel, client DNS mode, NFS client, gaming)
- **minipc**: Home server (LTS kernel, server DNS mode, NFS server, services)
- **minidesk**: Portable laptop (Zen kernel, standalone DNS mode, local storage)

## Updates

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager
```

## Common Patterns

### Adding a Service to minipc

1. Create feature module in `modules/nixos/features/`
2. Register in `nix/modules.nix`
3. If it needs a port, add to `nix/network-topology.nix` under `ports`
4. If it needs firewall ports opened, update `modules/nixos/platform/firewall.nix`:
   - Add feature detection (e.g., `myServiceEnabled = cfg.myservice.enable or false`)
   - Add ports to `tcpPorts` and/or `udpPorts` using `optional`
   - If it requires static IP, add to `servicesRequiringStaticIp` list
5. Enable in `hosts/minipc/default.nix` under `bigor.features`

**IMPORTANT:** Do NOT add firewall configuration to feature modules. The centralized firewall module handles all port openings automatically.

### Changing Network Configuration

1. Update `nix/network-topology.nix` for IPs/ports/domain
2. Update DNS policy in affected host configs if needed
3. Run `dns-test` after rebuild to validate

### Adding Dependencies Between Features

Don't create implicit dependencies. If feature A needs feature B, either:

- Make it a platform module (if truly required everywhere)
- Document in the feature description that users must enable both
- Use assertions to validate the requirement

Platform policies can auto-enable features.
