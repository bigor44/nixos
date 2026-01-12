# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal NixOS configuration repository using flake-parts for modular organization. It manages three hosts (minipc, grospc, minidesk) with a custom module system under the `bigor.*` namespace, integrating NixOS, Home Manager, nixvim, and sops-nix for secrets management.

## Quick Reference Commands

### Building and Testing

```bash
# Build without switching (recommended for testing)
nh os build

# Test configuration (reverts on reboot)
nh os test

# Apply changes permanently
nh os switch

# Build specific host
nh os build --hostname minipc
```

### Code Quality Workflow

**CRITICAL: These commands MUST be run in order before committing:**

```bash
# 1. Format code
nix fmt

# 2. Check for dead code
deadnix --fail .

# 3. Lint for anti-patterns
statix check --ignore .* .

# 4. Run all flake checks (includes assertions)
nix flake check
```

### Development Shell Shortcuts

When in the dev shell (`nix develop`), these aliases are available:

```bash
qc, check-quick    # Quick check (changed files only, <0.1s)
qs                 # Check staged files
qf, check-full     # Full check (CI-equivalent, ~16s)
mega, check-mega   # Intelligent check (adapts to git state)

# Workflows
gcn                # Add + format + check + commit
gps                # Full check + push
nhs                # Full check + rebuild (switch)
nhb                # Full check + rebuild (boot)
```

## Architecture

### Flake Structure

The flake uses flake-parts for organization:

- **flake.nix**: Main entry point, imports `nix/hosts.nix`, `nix/checks.nix`, `nix/devshell.nix`
- **nix/modules.nix**: Explicit import list for all custom NixOS and Home Manager modules
- **nix/hosts.nix**: Defines all NixOS configurations using `mkHost` helper
- **nix/checks.nix**: Automated checks (formatting, linting, policy assertions)
- **nix/devshell.nix**: Development environment with QA tools

### Module Organization

All modules use the `bigor.*` namespace and follow a strict categorization:

#### NixOS Modules (`modules/nixos/`)

**Features** (`bigor.features.*`): Optional capabilities with `enable` option

- System features: `base`, `boot`, `network`, `packages`, `sops`, `users`, `french-locale`
- Hardware features: `audio`, `desktop`, `gaming`, `flatpak`, `via`

**Policies** (`bigor.policies.*`): Strategic decisions with enum selection (NO `enable` option)

- `kernel`: Kernel selection ("server", "desktop", "hardened", "latest")
- `power`: Power management ("amd-pstate", "intel-pstate", "none")
- `dns.mode`: DNS strategy ("local-recursive", "lan-recursive", "portable", "cloud")
- `storage`: Storage configuration ("nfs-server", "nfs-client", "standalone")

Policies provide `computed` read-only values for services to consume.

**Services** (`bigor.services.*`): Network daemons with `enable` option

- `blocky`: Ad-blocking DNS proxy
- `caddy`: Reverse proxy and web server
- `nfs`: NFS server/client (auto-configured via storage policy)
- `sshd`: SSH daemon
- `unbound`: Recursive DNS resolver

**Profiles** (`bigor.profiles.*`): Composite configurations enabling multiple features

- `workstation`: Desktop with COSMIC DE, audio, gaming
- `homelab-master`: Server with DNS, Caddy, NFS

#### Home Manager Modules (`modules/home/features/`)

All under `bigor.home.features.*` namespace:

- `cli-packages`: CLI utilities
- `dev-scripts`: QA scripts (check-quick, check-full, check-mega)
- `git`: Git configuration
- `shell`: Zsh with aliases and plugins
- `nixvim`: Neovim configuration
- `gui`: GUI applications

#### Host Configurations (`hosts/`)

Each host has:

- `default.nix`: NixOS configuration (imports `hardware-configuration.nix`)
- `home.nix`: Home Manager configuration
- `hardware-configuration.nix`: Auto-generated hardware config

Hosts define policies and enable profiles/features. Example:

```nix
bigor = {
  policies = {
    kernel = "server";
    dns.mode = "local-recursive";
  };
  profiles.homelab-master.enable = true;
};
```

### Network Topology

Network topology is managed in two files:

1. **`nix/network-topology.nix`**: Pure data file containing:
   - **`hosts`**: All hosts with their IP addresses and network interfaces
   - **`subnet`**: Network CIDR (default: "192.168.1.0/24")
   - **`domain`**: Local domain name for all hosts (e.g., "bigor.lan")
   - **`ports`**: Standard port numbers for all services (blocky, unbound, caddy, nfs)

2. **`modules/nixos/features/system/network.nix`**: NixOS module providing:
   - **`bigor.network.*`** options (reads data from topology file)
   - **`bigor.network.domain`**: Read-only, local domain name from topology
   - **`bigor.network.mainInterface`**: Read-only, derived from current host's topology
   - `/etc/hosts` generation from topology
   - Network configuration logic (DNS, firewall)
   - Warnings when domain is not set

Services should reference `config.bigor.network.hosts.<hostname>.ip` instead of hardcoding IPs.

Current topology:

- minipc: 192.168.1.10 (enp2s0) - homelab server
- grospc: 192.168.1.11 (enp14s0) - workstation
- minidesk: DHCP (enp2s0) - portable laptop

### Policy System

Policies centralize strategic decisions to eliminate duplication across hosts:

1. **Declaration**: Policies use `mkOption` with `types.enum`, no `enable` option
2. **Implementation**: Set low-level NixOS options based on selected strategy
3. **Computed Values**: Provide read-only values via `computed.*` for services to consume
4. **Assertions**: Validate prerequisites for selected strategies
5. **Auto-enable**: Can auto-enable services (e.g., DNS policy enables Unbound when `mode = "local-recursive"`)

Example: DNS policy computes upstream servers based on strategy, services read `config.bigor.policies.dns.computed.blockyUpstreams`.

### Module Pattern

**Feature/Service modules** (with `enable` option):

```nix
{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.<category>.<module-name>;
in
{
  options.bigor.<category>.<module-name> = {
    enable = mkEnableOption "Description";
    # Additional options...
  };

  config = mkIf cfg.enable {
    # Implementation...
  };
}
```

**Policy modules** (NO `enable` option):

```nix
{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.bigor.policies.<policy-name>;
in
{
  options.bigor.policies.<policy-name> = mkOption {
    type = types.enum [ "strategy1" "strategy2" ];
    default = "strategy1";
    description = ''
      Policy description:
      - "strategy1": Description
      - "strategy2": Description
    '';
  };

  options.bigor.policies.<policy-name>.computed = {
    someValue = mkOption {
      type = types.bool;
      readOnly = true;
      default = cfg == "strategy2";
    };
  };

  config = {
    # Implement policy by setting NixOS options
    assertions = [ /* validate prerequisites */ ];
  };
}
```

### Code Style Conventions

1. **NO `with lib;`** - Use explicit imports: `inherit (lib) mkOption mkIf types;`
2. **Always use `mkEnableOption`** for feature/service enable options
3. **Prefer explicit over implicit** - makes dependencies clear
4. **Policy modules use `readOnly` options** for computed values
5. **Add assertions** to validate configuration coherence

These are enforced by statix linter (see `.statix.toml`).

### Secrets Management

- Uses sops-nix for encrypted secrets
- Age key required: `~/.config/sops/age/keys.txt`
- Edit secrets: `sops secrets/secrets.yaml`
- Reference in config: `config.sops.secrets.<key>.path`

### COSMIC DE Configuration

Files in `dotfiles/cosmic/` are **symlinked** (not copied). Changes take effect immediately without rebuild. Remember to commit changes after editing.

## Testing New Changes

1. **Make changes** to modules or host configs
2. **Format and check**: `nix fmt && deadnix --fail . && statix check --ignore .* . && nix flake check`
3. **Build**: `nh os build` (or `nh os build --hostname <host>`)
4. **Test**: `nh os test` (reverts on reboot)
5. **Apply**: `nh os switch` (permanent)

Policy assertions are validated during `nix flake check` - if a host configuration violates policy prerequisites, the check will fail with a descriptive error message.

## Adding New Components

### Adding a New Module

1. Create module file in `modules/nixos/features/<category>/` or `modules/nixos/services/`
2. Follow the module pattern (see above)
3. Add to `nix/modules.nix` in the appropriate list
4. Enable in host config: `bigor.<category>.<name>.enable = true;`

### Adding a New Policy

1. Create policy module in `modules/nixos/policies/<policy-name>.nix`
2. Use enum type with strategies, NO `enable` option
3. Add `computed.*` read-only values if needed
4. Add assertions to validate prerequisites
5. Add to `nix/modules.nix` under nixosModules
6. Set in host config: `bigor.policies.<policy-name> = "strategy";`

### Adding a New Host

1. Create `hosts/<hostname>/` directory
2. Create `default.nix` (NixOS config) and `home.nix` (Home Manager config)
3. Generate hardware config: `nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix`
4. Add to `nix/hosts.nix`: `<hostname> = mkHost "<hostname>";`
5. Add to network topology in `nix/network-topology.nix`:
   ```nix
   hosts.<hostname> = {
     ip = "192.168.1.XX";  # or null for DHCP
     interface = "enp0s0";
   };
   ```
6. Test: `nh os build --hostname <hostname>`

### Adding a New Service

1. Create service module in `modules/nixos/services/<name>.nix`
2. Follow module pattern with `enable` option
3. Reference network topology: `config.bigor.network.hosts.<hostname>.ip`
4. Reference policy computed values: `config.bigor.policies.<policy>.computed.<value>`
5. Add to `nix/modules.nix`
6. Add assertions to validate against policy requirements

## Important Files

- **flake.nix**: Main entry point
- **nix/modules.nix**: Module registry (add ALL new modules here)
- **nix/network-topology.nix**: Network topology data (all IPs, interfaces, ports)
- **modules/nixos/features/system/network.nix**: Network configuration module
- **modules/nixos/policies/**: Strategic decisions (kernel, power, DNS, storage)
- **.statix.toml**: Linter configuration and codebase conventions
- **treefmt.toml**: Formatter configuration
- **CONTRIBUTING.md**: Detailed development workflow and patterns
