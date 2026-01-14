# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Required Workflow for Claude

**CRITICAL**: When making changes to this repository, Claude MUST follow this workflow:

1. **Before making changes**: Use `check-quick` or `check-mega` to understand current state
2. **After editing files**: Run `nix fmt` to format changes
3. **Before committing**: Run `check-full` to validate all changes
4. **For system rebuilds**: Use `nh` workflows (`nhs`, `nhb`) which include automatic validation

### Quality Check Commands (REQUIRED)

```bash
# Quick validation (use frequently during development)
check-quick              # Check unstaged changes (<0.1s) - USE THIS OFTEN
check-mega               # Intelligent check (adapts to git state) - PREFERRED

# Full validation (before commits/pushes)
check-full               # Complete CI-equivalent check (~16s) - REQUIRED BEFORE COMMITS

# Format code (required after edits)
nix fmt                  # Format all files - RUN AFTER EDITS

# Safe rebuild workflows (includes validation)
nhs                      # Full check + rebuild switch - USE INSTEAD OF nixos-rebuild
nhb                      # Full check + rebuild boot
```

**Why these tools?**

- They enforce format, lint, and policy checks automatically
- They're faster than manual `nix flake check`
- They prevent broken configurations from being committed
- The nh tools (`nhs`, `nhb`) include safety checks before rebuilding

## Build and Development Commands

### Testing and Validation

```bash
# Enter development shell (auto-installs pre-commit hooks)
nix develop

# Quick checks (fast, incremental)
check-quick              # Check unstaged changes (<0.1s)
check-quick --staged     # Check staged changes
qc                       # Alias for check-quick

# Full checks (CI-equivalent, ~16s)
check-full               # Format, lint, dead code, evaluation, flake checks
qf                       # Alias for check-full

# Intelligent checks (adapts to git state)
check-mega               # Analyzes git state and runs appropriate check
mega                     # Alias for check-mega

# DNS functional tests
dns-test                 # Validate local DNS, ad blocking, DNSSEC
```

### Building and Deploying

```bash
# PREFERRED: Use nh workflows (includes automatic validation)
nhs                      # Full check + rebuild switch (RECOMMENDED)
nhb                      # Full check + rebuild boot (RECOMMENDED)

# Manual builds (when nh workflows not appropriate)
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Direct rebuild (NOT RECOMMENDED - use nhs/nhb instead)
sudo nixos-rebuild switch --flake .

# Git workflows (combine checks + operations)
gps                      # Full check + push
gcn                      # Add + format + check + commit
```

### Formatting and Linting

```bash
# Format all files (REQUIRED after editing)
nix fmt                  # Uses treefmt (nixfmt, shfmt, prettier, taplo)

# PREFERRED: Use check-quick/check-full instead of manual commands below
check-quick              # Fast format + lint + dead code check
check-full               # Complete validation (includes flake checks)

# Manual linting (only use for debugging)
statix check .           # Linter
deadnix --fail .         # Dead code detection

# Flake operations
nix flake check          # Run all flake checks (includes policy assertions)
nix flake show           # Evaluate flake structure
```

### Secret Management

```bash
# Edit SOPS-encrypted secrets
sops secrets/example.yaml

# Validate secrets
sops -d secrets/example.yaml
```

## Architecture

### Flake Structure (flake-parts)

This repository uses **flake-parts** for modular flake organization:

- `flake.nix` - Entry point, imports parts from `nix/`
- `nix/hosts.nix` - Defines all NixOS configurations via `mkHost` helper
- `nix/modules.nix` - Explicit import list for all custom modules
- `nix/checks.nix` - CI checks (format, lint, policy assertions)
- `nix/devshell.nix` - Development shell with QA tools
- `nix/network-topology.nix` - Centralized network data (IPs, ports, topology)

### Module Organization: Platform vs Capabilities

**Core Principle**: Separate always-active infrastructure (platform) from optional features (capabilities).

#### Platform Modules (`modules/nixos/platform/`)

Always-active infrastructure and strategic policies. Never gated by `enable` option.

- `boot.nix` - Bootloader, kernel, Plymouth
- `fonts.nix` - System fonts and font configuration
- `localization.nix` - Timezone, locale, keyboard
- `network.nix` - Network topology injection (IPs, ports, domain)
- `packages.nix` - Core system packages
- `sops.nix` - Secret management via SOPS
- `users.nix` - User account management
- `policies/dns.nix` - DNS resolution strategy (local/LAN/portable/cloud)
- `policies/storage.nix` - Storage strategy (standalone/NFS)

**Policy Modules**: Compute strategic decisions and provide read-only values to capabilities. Example: DNS policy computes Blocky upstreams based on mode (local-recursive, lan-recursive, portable, cloud).

#### Capability Modules (`modules/nixos/capabilities/`)

Optional features, always gated by `enable = mkEnableOption`.

- `audio.nix` - PipeWire audio stack
- `blocky.nix` - DNS ad-blocker (reads from DNS policy)
- `bluetooth.nix` - Bluetooth support
- `caddy.nix` - Reverse proxy with internal CA
- `cpu-power-management.nix` - Laptop power management
- `desktop.nix` - COSMIC desktop environment
- `flatpak.nix` - Flatpak support
- `gaming.nix` - Steam, Lutris, gamemode
- `nfs.nix` - NFS server/client (reads from storage policy)
- `sshd.nix` - SSH server
- `unbound.nix` - Recursive DNS resolver
- `keyboardVIA.nix` - VIA keyboard configurator

### Host Configuration Pattern

Each host consists of two files in `hosts/<hostname>/`:

1. `default.nix` - System configuration (kernel, capabilities, policies)
2. `home.nix` - Home Manager configuration for user `bigor`

Example host structure:

```nix
# hosts/grospc/default.nix
{
  networking.hostName = "grospc";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    platform.policies = {
      dns.mode = "lan-recursive";
      storage.mode = "nfs-client";
    };
    capabilities = {
      blocky.enable = true;
      desktop.enable = true;
      audio.enable = true;
      flatpak.enable = true;
      bluetooth.enable = true;
      gaming.enable = true;
    };
  };
}
```

### Network Topology (`nix/network-topology.nix`)

Centralized data structure for all network information:

- Host IPs and interfaces
- Service port numbers
- Subnet and domain
- Injected into all modules via `config.bigor.network`

### Home Manager Modules (`modules/home/`)

User-level configuration:

- `cli-packages.nix` - CLI tools and utilities
- `dev-scripts.nix` - QA scripts (check-quick, check-full, etc.)
- `git.nix` - Git configuration
- `gui.nix` - GUI applications (when `bigor.home.gui.enable = true`)
- `shell/` - Zsh, Starship, shell tools
- `nixvim/` - Neovim configuration via nixvim

## Coding Conventions

### Module Pattern

All custom modules follow this pattern:

```nix
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.bigor.<category>.<module>;
in
{
  options.bigor.<category>.<module> = {
    enable = mkEnableOption "description";
  };

  config = mkIf cfg.enable {
    # Implementation
  };
}
```

### Style Rules (enforced by `.statix.toml`)

1. **NO `with lib;`** - Use explicit imports:

   ```nix
   # Good
   inherit (lib) mkOption mkIf mkEnableOption types;

   # Bad
   with lib;
   ```

2. **Use `mkEnableOption`** for all capability modules:

   ```nix
   # Good
   enable = mkEnableOption "Feature description";

   # Bad
   enable = mkOption { type = types.bool; default = false; };
   ```

3. **Policy modules use `readOnly` options** for computed values:
   ```nix
   computed.value = mkOption {
     type = types.str;
     readOnly = true;
     default = # ...computation
   };
   ```

### Policy Assertions

Strategic constraints validated via `assertions` in policy modules. All assertions are checked during `nix flake check`:

```nix
assertions = [
  {
    assertion = cfg.mode == "local-recursive" -> networkCfg.hosts.${hostname}.ip != null;
    message = "DNS policy 'local-recursive' requires a static IP for ${hostname}";
  }
];
```

## Hosts Overview

- **minipc** - Home server (DNS: local-recursive, Storage: NFS server)
- **grospc** - Desktop workstation (DNS: lan-recursive, Storage: NFS client, gaming)
- **minidesk** - Portable laptop (DNS: portable, DHCP)

## Git Workflow

### Safe Workflow Commands

Use these composite commands that include automatic validation:

```bash
gcn                      # nix fmt + add all + check staged + commit
gps                      # check-full + push
```

These commands ensure code is validated before commits/pushes.

### Pre-commit Hooks

Pre-commit hooks are auto-installed on entering dev shell:

- Format/lint check on staged `.nix` files (uses `check-quick --staged`)
- SOPS secret validation
- Prevent committing sensitive files (`.pem`, `.key`, etc.)

Skip with: `git commit --no-verify` (not recommended)

### Workflow Aliases Breakdown

```bash
# gcn = "nix fmt && gaa && qs && gc"
# gaa = git add --all
# qs = check-quick --staged
# gc = git commit

# gps = "check-full && gp"
# gp = git push

# nhs = "check-full && nh os switch"
# nhb = "check-full && nh os boot"
```

## Claude Code Usage Guidelines

When working in this repository, Claude Code should:

### Always Use Validation Tools

1. **After editing any .nix files**: Run `nix fmt`
2. **During development**: Run `check-quick` or `check-mega` frequently
3. **Before proposing commits**: Run `check-full` to ensure all checks pass
4. **For system rebuilds**: Use `nhs` or `nhb` instead of raw `nixos-rebuild` commands

### Typical Workflow

```bash
# 1. Make changes to .nix files
vim modules/nixos/capabilities/example.nix

# 2. Format the changes
nix fmt

# 3. Quick validation
check-quick

# 4. If validation passes and ready to commit
gcn  # Formats, adds, checks staged files, commits

# 5. Before pushing
gps  # Full check + push

# 6. For system rebuild
nhs  # Full check + rebuild switch
```

### Why This Matters

- Prevents broken configurations from being committed
- Ensures policy assertions are validated
- Maintains consistent code style
- Catches dead code and linting issues early
- Reduces CI failures and rebuild errors

The dev-scripts and nh tools are specifically designed for this workflow and should be preferred over manual commands.
