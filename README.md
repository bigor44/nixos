# Bigor NixOS Configuration

## Overview

This repository contains my personal **NixOS + Home Manager** configuration, designed as a **single, structured, reproducible mono-repo** for:

- Desktop workstations
- Portable machines
- Homelab / server infrastructure

The configuration is built around **flakes**, **flake-parts**, and **Home Manager**, with a strong emphasis on:

- Modularity and clear separation of concerns
- Reusability across multiple hosts
- Declarative system and user environments
- A production-grade homelab DNS stack

This repository is intended to be **shared, audited, and reused as inspiration** rather than copied blindly.

---

## Hosts

| Host         | Role                 | Description                                  |
| ------------ | -------------------- | -------------------------------------------- |
| **grospc**   | Desktop workstation  | COSMIC DE, gaming optimizations, NFS client  |
| **minipc**   | Server               | DNS/network server, NFS server               |
| **minidesk** | Portable workstation | Same hardware as minipc, DHCP, local storage |

---

## Key Design Principles

- **Single source of truth** for systems and users
- **Policy-driven configuration** - strategic decisions (kernel, DNS, storage) centralized and explicit
- **Feature-based composition** instead of host-specific snowflakes
- **Profiles** to express machine roles (workstation, server, etc.)
- **Strict formatting and linting** enforced via flake checks
- **Minimal runtime magic** - behavior is explicit and traceable

---

## Repository Structure

```
.
├── flake.nix               # Flake-parts entry point
├── flake.lock              # Dependency lockfile
├── treefmt.toml            # Formatting configuration
├── .statix.toml            # Statix linter configuration
├── nix/
│   ├── modules.nix         # Explicit module import list
│   ├── hosts.nix           # NixOS configuration definitions
│   ├── checks.nix          # Flake checks (formatting, linting)
│   └── devshell.nix        # Development shell with QA tools
├── hosts/                  # Host-specific configurations
│   ├── grospc/
│   │   ├── default.nix     # NixOS config
│   │   ├── hardware-configuration.nix
│   │   └── home.nix        # Home Manager config
│   ├── minipc/
│   └── minidesk/
├── users/                  # Base user configurations
│   └── bigor/
├── modules/
│   ├── home/
│   │   └── features/       # Home Manager feature modules
│   └── nixos/
│       ├── features/       # NixOS feature modules
│       ├── services/       # NixOS service modules
│       ├── policies/       # Strategic decision modules (kernel, DNS, storage)
│       └── profiles/       # Composite profiles
├── dotfiles/               # COSMIC DE and autostart configs
├── scripts/                # Utility & automation scripts
├── secrets/                # SOPS-encrypted secrets (not public)
└── certs/                  # Internal CA certificates
```

---

## Architecture

### 1. Flakes & Flake-parts

The repository uses **flake-parts** to organize the configuration into distinct layers:

- **`policies`** (`modules/nixos/policies/`) - Strategic decisions with authoritative validation
  - What kernel, DNS strategy, storage mode, power management
  - Provides computed values for services to consume
  - Validates prerequisites (static IP, device availability, mode coherence)

- **`features`** (`modules/nixos/features/`) - Atomic, reusable building blocks
  - System features (boot, network, locale, fonts, etc.)
  - Desktop features (COSMIC, audio, gaming, etc.)

- **`services`** (`modules/nixos/services/`) - System services with pure implementation
  - DNS (Blocky, Unbound), SSH, NFS, Caddy
  - Consume policy decisions, validate technical constraints only

- **`profiles`** (`modules/nixos/profiles/`) - Machine roles composed of features and services
  - Workstation, homelab server, etc.

All configuration lives under the `bigor.*` namespace to avoid collisions
with upstream NixOS or Home Manager options.

Module imports are explicit in `nix/modules.nix` for clarity and maintainability.

---

### 2. Policy Layer

The configuration uses a **policy layer** to separate strategic decisions ("what") from implementation details ("how").

#### Available Policies

- **`bigor.policies.kernel`** - Kernel selection
  - `"server"`: LTS kernel for stability
  - `"desktop"`: Zen kernel for performance
  - `"hardened"`: Security-focused kernel
  - `"latest"`: Latest mainline kernel

- **`bigor.policies.power`** - System-wide power management
  - `"amd-pstate"`: AMD P-State EPP active mode + power-profiles-daemon
  - `"intel-pstate"`: Intel P-State active mode + power-profiles-daemon
  - `"performance"`: Maximum performance with performance governor
  - `"balanced"`: Default kernel behavior, no explicit governor
  - `"powersave"`: Maximum power saving with powersave governor
  - P-State modes enable runtime power profile switching via desktop environments

- **`bigor.policies.dns.mode`** - DNS resolution strategy
  - `"local-recursive"`: Run Unbound + Blocky locally (server role)
  - `"lan-recursive"`: Use LAN recursive resolver (workstation)
  - `"portable"`: Cloud DNS only, no LAN dependencies
  - `"cloud"`: Direct cloud DNS (future: no filtering)

- **`bigor.policies.storage.mode`** - Storage access strategy
  - `"nfs-server"`: Export local storage via NFS
  - `"nfs-client"`: Mount storage from minipc
  - `"local"`: Local storage mount, no network sharing
  - `"none"`: No storage mount

#### Example Host Configuration

```nix
bigor = {
  # Policies: strategic decisions visible at a glance
  policies = {
    kernel = "desktop";
    power = "amd-pstate";
    dns.mode = "lan-recursive";
    storage.mode = "nfs-client";
  };

  # Profile: feature composition
  profiles.workstation.enable = true;
};
```

#### Benefits

- **No duplication**: Kernel/power settings declared once (not in 3 places)
- **Clear intent**: All strategic decisions visible at a glance
- **Simplified services**: Blocky, Unbound, NFS are pure implementation
- **Centralized validation**: Assertions validate policy coherence in the policy layer
- **Easy global changes**: Change all desktops to latest kernel in one place
- **Service flexibility**: Advanced users can override policy when needed
  - Blocky: `followDnsPolicy = false` for manual upstream configuration
  - NFS: Direct options available but assertion-protected for safety

#### Assertion Architecture

The configuration uses a **two-layer assertion architecture** to separate strategic validation from technical validation:

**Policy Layer** (`modules/nixos/policies/`) - Authoritative source for strategic assertions:

- Validates prerequisites: static IP requirements, device availability, mode coherence
- Examples:
  - DNS `local-recursive` mode requires static IP
  - DNS `lan-recursive` mode requires minipc to have static IP
  - Storage `nfs-server` mode requires static IP + local device
  - Storage `nfs-client` mode requires static IP
  - Storage `nfs-server`/`local` modes require device specified

**Service Layer** (`modules/nixos/services/`, `modules/nixos/features/`) - Technical assertions only:

- Validates implementation constraints that are independent of strategic decisions
- Examples:
  - Cannot enable both NFS server and client simultaneously
  - localStorage requires a device to be specified
- **No duplication** of strategic validations from the policy layer

This architecture provides:

- **Single source of truth**: Strategic validations are authoritative in policies
- **Maintainability**: Changing a validation rule only requires updating the policy module
- **Clear separation**: Strategic prerequisites vs technical constraints
- **Helpful error messages**: Policy assertions guide users to the recommended configuration path

---

### 3. NixOS Configuration

NixOS modules are organized by concern:

- **Policies**: Strategic decisions (kernel, power, DNS, storage)
- **System features**: boot, locale, fonts, networking, users
- **Desktop features**: COSMIC desktop, audio, gaming
- **Services**: Blocky, Unbound, SSH, Caddy, NFS
- **Profiles**: workstation, homelab server

Example workstation:

```nix
bigor = {
  policies = {
    kernel = "desktop";
    power = "amd-pstate";
    dns.mode = "lan-recursive";
    storage.mode = "nfs-client";
  };
  profiles.workstation.enable = true;
};
```

Example server:

```nix
bigor = {
  policies = {
    kernel = "server";
    power = "amd-pstate";
    dns.mode = "local-recursive";
    storage = {
      mode = "nfs-server";
      device = "/dev/disk/by-uuid/...";
    };
  };
  profiles.homelab-master.enable = true;
};
```

---

### 4. Home Manager

Home Manager is integrated via the NixOS module and used for:

- Shell (Zsh + Starship)
- CLI tooling (eza, fd, ripgrep, btop, lazygit, etc.)
- Git configuration
- Neovim (via nixvim)
- GUI applications (per host)
- Development QA scripts (check-quick, check-full, check-mega, install-git-hooks)

All Home Manager modules use the `bigor.home.features.*` namespace:

```nix
bigor.home.features.shell.enable = true;
bigor.home.features.nixvim.enable = true;
bigor.home.features.dev-scripts.enable = true;  # QA scripts
bigor.home.features.gui.enable = true;
```

Configuration is organized per host with a shared base:

```
hosts/
├── grospc/
│   └── home.nix    # Imports users/bigor + host-specific overrides
├── minipc/
│   └── home.nix
└── minidesk/
    └── home.nix

users/
└── bigor/
    └── default.nix # Base user configuration
```

---

## Neovim (NixVim)

Neovim is configured declaratively using **nixvim**, with:

- LSP (nixd, bashls, yaml, json, markdown)
- Treesitter
- Telescope, Neo-tree, Git integration
- Mini.nvim ecosystem
- Clean, documented keymaps

**nixd** is configured to use the flake's locked nixpkgs for consistent
autocompletion and diagnostics.

The configuration is modular and split by responsibility:

```
modules/home/features/nixvim/
├── default.nix
├── opts.nix
├── keymaps.nix
├── autocmds.nix
└── plugins/
```

---

## DNS Stack (Homelab)

A central part of the repository is a **production-grade DNS stack**:

### Components

- **Unbound** - recursive DNS resolver with DNSSEC validation
- **Blocky** - DNS proxy with ad/tracker blocking and failover

### Features

- Central DNS server for the LAN
- Automatic failover to external resolvers
- DNSSEC validation
- Local domain rewrites (`*.bigor.lan`)
- Privacy-friendly logging
- **SPOF mitigation**: Fallback to external DNS (1.1.1.1) if Blocky is down
- **Policy-driven modes**: DNS strategy configured via `bigor.policies.dns.mode`
  - `local-recursive`: minipc runs both Unbound and Blocky
  - `lan-recursive`: workstations use minipc as upstream
  - `portable`: minidesk uses cloud DNS only (no LAN dependencies)

### Network Topology

All hosts are declared in a central registry:

```nix
bigor.network.hosts = {
  minipc   = { ip = "192.168.1.10"; interface = "enp2s0"; };
  grospc   = { ip = "192.168.1.11"; interface = "enp14s0"; };
  minidesk = { ip = null; interface = "enp2s0"; };  # DHCP
};
```

This registry is used to generate:

- `/etc/hosts`
- DNS rewrites
- Firewall rules
- Service bindings

**Single Source of Truth**: `mainInterface` is automatically derived from the hosts topology - no manual configuration needed.

**Validation**: Assertions ensure configuration consistency at build time:

**Network Layer** (in `modules/nixos/features/system/network.nix`):

- Hostname must exist in the hosts registry
- Static IP requires an interface

**Policy Layer** (in `modules/nixos/policies/`):

- DNS `local-recursive` mode requires static IP
- DNS `lan-recursive` mode requires minipc to have static IP
- Storage `nfs-server` mode requires static IP + local device
- Storage `nfs-client` mode requires static IP
- Storage `nfs-server`/`local` modes require device specified

**Service Layer** (in `modules/nixos/services/`):

- Technical constraints (e.g., cannot be NFS server and client simultaneously)
- No duplication of strategic validations

This prevents typos and misconfigurations at build time with clear error messages.

---

## Secrets Management (SOPS)

Secrets are managed using **sops-nix** with **age**:

- Secrets are encrypted at rest
- Decrypted only at activation time
- SSH host keys are reused as age identities

> The `secrets/` directory is intentionally excluded from public sharing.

---

## Quality Assurance & Tooling

### 3-Tier QA System

The repository uses a **3-tier QA system** optimized for speed during development while maintaining CI-grade validation:

**Tier 1 - Instant (< 0.1s)** - Changed files only:

```bash
qc              # Quick check on modified files
qs              # Quick check on staged files
check-quick     # Explicit command
```

**Tier 2 - Full (~16.5s)** - Complete validation:

```bash
qf              # Full check: format + lint + dead code + eval + flake checks
check-full      # Explicit command
nix flake check # Raw Nix flake checks (still works)
```

**Tier 3 - Intelligent** - Adaptive based on git state:

```bash
mega            # Analyzes git state and runs appropriate check
check-mega      # Explicit command
```

### Performance Improvement

| Workflow       | Before (manual) | After (QA system) | Speedup |
| -------------- | --------------- | ----------------- | ------- |
| Dev cycle      | 16.5s           | 0.03s             | 500x    |
| Pre-commit     | Manual/skipped  | Automatic, <0.1s  | ∞       |
| Pre-push       | Not validated   | 16.5s (automatic) | N/A     |
| CI equivalence | 16.5s           | 16.5s (same)      | 1x      |

### Pre-Commit Hooks

Pre-commit hooks automatically validate changes before commit:

**Installation** (one-time per clone):

```bash
# Automatic via devShell (recommended)
nix develop

# Manual installation
install-git-hooks
```

**What it validates:**

- Format check on staged `.nix` files (nixfmt)
- Linter check (statix + deadnix)
- SOPS secrets validation (if modified)
- Prevention of sensitive file commits (`.pem`, `.key`, etc.)

**Skip when needed:**

```bash
git commit --no-verify
```

### Safe Workflow Aliases

**gcn** - Safe commit (format + add all + check + commit):

```bash
gcn -m "feat: add new feature"
```

**gps** - Safe push (full check before push):

```bash
gps
```

**nhs** - Safe rebuild (full check before switch):

```bash
nhs
```

### Development Workflow

**Recommended workflow:**

1. **Develop**: Edit code, run `qc` after changes (instant feedback)
2. **Format**: Run `nix fmt` before staging
3. **Commit**: Use `gcn -m "message"` (validates automatically)
4. **Push**: Use `gps` (full check + push)

### Quality Tools

The repository enforces quality through automated checks:

- **treefmt** - formatting enforcement (nixfmt, shfmt, prettier, taplo)
- **statix** - Nix linting (configured via `.statix.toml`)
- **deadnix** - unused code detection

Configuration:

- `.statix.toml` - Documents code conventions and disables overly strict rules
- `treefmt.toml` - Multi-language formatting configuration
- `nix/checks.nix` - Flake check definitions

### DevShell

A development shell is provided with all QA tools:

```bash
nix develop
```

Includes:

- All formatters (treefmt, nixfmt, shfmt, prettier, taplo)
- Linters (statix, deadnix)
- Build tools (nh)
- Secrets management (sops, age)
- Auto-installation of pre-commit hooks

---

### DNS Post-Switch Test

A post-deployment DNS test script is provided:

```bash
scripts/dns-test.sh
```

It validates:

- DNS reachability
- Local rewrites
- External resolution
- Ad blocking
- DNSSEC validation

This test is intentionally **not** part of `nix flake check`, as it is a
runtime verification step.

---

## Supported Systems

Currently supported:

- `x86_64-linux`

Multi-architecture support can be added by extending the `systems` list in `flake.nix`.

---

## How to Use This Repository

### Clone

```bash
git clone https://github.com/bigor44/nixos.git
cd nixos
```

### Build or Switch (using nh)

```bash
# Rebuild and switch to new configuration
nh os switch

# Build without switching
nh os build

# Test configuration (reverts on reboot)
nh os test

# Build specific host
nh os switch --hostname minipc
```

### Build or Switch (traditional)

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

---

## Disclaimer

This repository reflects **personal infrastructure choices**.

While the configuration is designed to be robust and reusable, you should:

- Review all security-related settings
- Adapt network assumptions
- Adjust secrets handling

Use this repository as a **reference implementation**, not a drop-in solution.

---

## License

This repository is shared under the MIT license.

You are free to reuse, modify, and adapt it, with attribution appreciated.

---

## Contact

Maintained by **Yoann Bigor**.

Questions, discussions, or improvements are welcome via GitHub issues or pull requests.
