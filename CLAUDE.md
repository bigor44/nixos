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

**CRITICAL: Always validate changes before committing:**

```bash
# Preferred: Run all checks in one command
check-full   # or: qf

# This runs: format + deadnix + statix + nix flake check
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

### Development Scripts

All development scripts are provided by `bigor.home.features.dev-scripts`:

**Quality Assurance:**

- `check-quick` (alias: `qc`): Fast incremental check on changed files (<0.1s)
- `check-full` (alias: `qf`): Complete CI-equivalent check (~16s)
  - Runs: format check, dead code check, linter, evaluation, flake checks
- `check-mega` (alias: `mega`): Intelligent orchestrator that adapts to git state
  - Clean tree with unpushed commits → full check
  - Staged files → quick check on staged
  - Modified files → quick check on modified

**Testing:**

- `dns-test`: DNS stack functional test
  - Validates: DNS reachability, local rewrites, external resolution, ad blocking, DNSSEC

**Git Hooks:**

- `install-git-hooks`: Install pre-commit hook for automatic validation
  - Checks: format/lint on staged .nix files, SOPS secrets validation, sensitive file prevention
  - Skip with: `git commit --no-verify`

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

**Common** (`modules/nixos/common/`): Non-optional base configuration applied to all hosts

- `boot`: Bootloader configuration (UEFI systemd-boot)
- `localization`: French locale, timezone (Europe/Paris), and keyboard layout
- `network`: Network topology, `/etc/hosts` generation, firewall (provides `bigor.network.*` options)
- `packages`: Essential CLI tools (zsh, tmux, nh, etc.)
- `sops`: Secrets management base configuration
- `users`: User account management

Note: Core Nix settings (binary caches, flakes, trusted users, internal CA) are configured directly in `nix/hosts.nix` as they apply universally to all hosts.

**Features** (`bigor.features.*`): Optional capabilities with `enable` option

- Desktop features: `audio`, `desktop`, `gaming`, `flatpak`, `via`
- Hardware features: `cpu-power-management` (auto-detects AMD/Intel and configures P-States)

**Policies** (`bigor.policies.*`): Strategic decisions with enum selection (NO `enable` option)

- `dns.mode`: DNS strategy ("local-recursive", "lan-recursive", "portable", "cloud")
- `storage.mode`: Storage configuration ("nfs-server", "nfs-client", "local", "none")

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
- `dev-scripts`: Development scripts (check-quick, check-full, check-mega, dns-test, install-git-hooks)
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
{ pkgs, ... }:
{
  # Kernel selection (direct NixOS option)
  boot.kernelPackages = pkgs.linuxPackages;

  bigor = {
    policies = {
      dns.mode = "local-recursive";
      storage.mode = "nfs-server";
    };
    features.cpu-power-management.enable = true;
    profiles.homelab-master.enable = true;
  };
}
```

### Network Topology

Network topology is managed in two files:

1. **`nix/network-topology.nix`**: Pure data file containing:
   - **`hosts`**: All hosts with their IP addresses and network interfaces
   - **`subnet`**: Network CIDR (default: "192.168.1.0/24")
   - **`domain`**: Local domain name for all hosts (e.g., "bigor.lan")
   - **`ports`**: Standard port numbers for all services (blocky, unbound, caddy, nfs)

2. **`modules/nixos/common/network.nix`**: NixOS module providing:
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

Policies centralize **strategic architectural decisions** that have complex downstream effects across multiple services. They should only be used when a decision:

1. Represents fundamentally different architectural patterns
2. Has cascading effects on multiple services
3. Requires complex validation and computed values
4. Is used differently across multiple hosts

**Current policies:**

- **DNS**: Manages DNS resolution strategy with auto-configuration of Unbound and Blocky
- **Storage**: Manages NFS server/client/local storage patterns

**Policy characteristics:**

1. **Declaration**: Use `mkOption` with `types.enum`, NO `enable` option
2. **Implementation**: Set low-level NixOS options based on selected strategy
3. **Computed Values**: Provide read-only values via `computed.*` for services to consume
4. **Assertions**: Validate prerequisites for selected strategies
5. **Auto-enable**: Can auto-enable services (e.g., DNS policy enables Unbound when `mode = "local-recursive"`)

Example: DNS policy computes upstream servers based on strategy, services read `config.bigor.policies.dns.computed.blockyUpstreams`.

**When NOT to use policies:** Simple configuration choices should use direct NixOS options (e.g., `boot.kernelPackages`) or auto-detecting features (e.g., `cpu-power-management`).

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
2. **Validate**: `check-full` (runs format + deadnix + statix + flake check)
3. **Build**: `nh os build` (or `nh os build --hostname <host>`)
4. **Test**: `nh os test` (reverts on reboot)
5. **Apply**: `nh os switch` (permanent)

Policy assertions are validated during `nix flake check` - if a host configuration violates policy prerequisites, the check will fail with a descriptive error message.

### Testing DNS Stack

Test DNS functionality on hosts with DNS services enabled:

```bash
dns-test
```

This validates:

1. DNS server reachability (127.0.0.1)
2. Local domain resolution (e.g., minipc.bigor.lan)
3. External domain resolution (e.g., google.com)
4. Ad blocking effectiveness (ads.youtube.com → 0.0.0.0)
5. DNSSEC validation

**Note**: This test requires `bigor.home.features.dev-scripts.enable = true` in your Home Manager configuration.

## Adding New Components

### Adding a New Module

**For optional features or services:**

1. Create module file in `modules/nixos/features/` (or subdirectory) or `modules/nixos/services/`
2. Follow the feature/service module pattern with `enable` option (see above)
3. Add to `nix/modules.nix` in the appropriate list
4. Enable in host config: `bigor.<category>.<name>.enable = true;`

**For non-optional base configuration:**

1. Create module file in `modules/nixos/common/`
2. Configuration is applied to all hosts automatically (no `enable` option)
3. Add to `nix/modules.nix` under the `nixosModules` common section
4. Or add directly to `nix/hosts.nix` if it's truly universal infrastructure config

### Adding a New Policy

**IMPORTANT**: Only create a policy if it meets ALL criteria:

- Represents fundamentally different architectural patterns
- Has complex downstream effects on multiple services
- Requires computed values used by other modules
- Is used differently across multiple hosts
- Cannot be replaced by direct NixOS options or auto-detection

If your use case doesn't meet these criteria, use a feature module or direct NixOS configuration instead.

**If you must create a policy:**

1. Create policy module in `modules/nixos/policies/<policy-name>.nix`
2. Use enum type with strategies, NO `enable` option
3. Add `computed.*` read-only values for services to consume
4. Add assertions to validate prerequisites
5. Add to `nix/modules.nix` under nixosModules
6. Set in host config: `bigor.policies.<policy-name>.mode = "strategy";`

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
- **nix/hosts.nix**: Host definitions and universal Nix configuration (caches, flakes, CA)
- **nix/modules.nix**: Module registry (add ALL new modules here)
- **nix/network-topology.nix**: Network topology data (all IPs, interfaces, ports)
- **modules/nixos/common/**: Non-optional base configuration for all hosts
- **modules/nixos/common/network.nix**: Network configuration module (provides `bigor.network.*`)
- **modules/nixos/policies/**: Strategic architectural decisions (DNS, storage)
- **modules/nixos/features/**: Optional capabilities with `enable` option
- **modules/nixos/features/hardware/**: Hardware-specific features with auto-detection
- **.statix.toml**: Linter configuration and codebase conventions
- **treefmt.toml**: Formatter configuration
- **CONTRIBUTING.md**: Detailed development workflow and patterns
