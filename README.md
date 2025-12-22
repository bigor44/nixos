# Bigor NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue?logo=nixos)](https://nixos.org)
[![Flakes](https://img.shields.io/badge/Nix-Flakes-informational?logo=nixos)](https://wiki.nixos.org/wiki/Flakes)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A modular, opinionated, and production-ready **NixOS + Home Manager** configuration built with **Flakes** and **snowfall-lib**.

```
                   +-----------------+
                   |   flake.nix     |
                   +--------+--------+
                            |
          +-----------------+-----------------+
          |                 |                 |
  +-------v-------+ +-------v-------+ +-------v-------+
  |   systems/    | |   modules/    | |    homes/     |
  | (Host configs)| | (NixOS + HM)  | | (User envs)   |
  +---------------+ +-------+-------+ +---------------+
                            |
          +-----------------+-----------------+
          |                 |                 |
  +-------v-------+ +-------v-------+ +-------v-------+
  |   profiles/   | |   features/   | |   services/   |
  | (Presets)     | | (Capabilities)| | (Daemons)     |
  +---------------+ +---------------+ +---------------+
```

---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Features](#features)
- [Repository Structure](#repository-structure)
- [Hosts](#hosts)
- [Key Design Principles](#key-design-principles)
  - [1. Snowfall-driven architecture](#1-snowfall-driven-architecture)
  - [2. Profile-based configuration](#2-profile-based-configuration)
  - [3. Network Topology (SSOT)](#3-network-topology-ssot)
  - [4. Modular DNS Stack (Blocky + Unbound)](#4-modular-dns-stack-blocky--unbound)
    - [Pattern 1: Full Stack (minipc)](#pattern-1-full-stack-minipc)
    - [Pattern 2: Remote Unbound (grospc)](#pattern-2-remote-unbound-grospc)
    - [Pattern 3: Standalone (minidesk)](#pattern-3-standalone-minidesk)
  - [5. Home Manager as a first-class citizen](#5-home-manager-as-a-first-class-citizen)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Code Quality \& Tooling](#code-quality--tooling)
- [Secrets Management](#secrets-management)
- [Dependencies](#dependencies)
- [What This Is (and Is Not)](#what-this-is-and-is-not)
- [License](#license)
- [Author](#author)

---

## Features

| Category            | Description                                                               |
| ------------------- | ------------------------------------------------------------------------- |
| **Multi-host**      | Desktop workstation + homelab server from a single codebase               |
| **Declarative**     | 100% reproducible system and user environments                            |
| **Home Manager**    | Per-user, per-host configurations with host-specific overrides            |
| **Neovim (nixvim)** | Full IDE experience: LSP, Treesitter, completion, formatting              |
| **Desktop**         | COSMIC DE, PipeWire audio, fonts, gaming optimizations                    |
| **Homelab**         | Unbound+Blocky DNS, Caddy, Prometheus, Grafana, Alertmanager, Ollama, NFS |
| **Secrets**         | sops-nix with age encryption                                              |
| **CI Checks**       | statix, deadnix, treefmt (nixfmt, shfmt, prettier, taplo)                 |

---

## Repository Structure

```
.
├── flake.nix              # Flake entry point
├── flake.lock             # Locked dependencies
├── checks/                # CI-style checks (statix, deadnix, formatting)
│
├── homes/                 # Home Manager entry points
│   └── x86_64-linux/
│       ├── bigor/         # Generic user profile
│       ├── bigor@minipc/  # Host-specific overrides
│       └── bigor@grospc/
│
├── modules/
│   ├── home/              # Home Manager modules (shell, git, nixvim, GUI, CLI)
│   └── nixos/             # NixOS modules
│       ├── features/      # System and desktop features
│       ├── profiles/      # High-level profiles (workstation, homelab_master)
│       └── services/      # Declarative services (Unbound, Blocky, Caddy, Monitoring, etc.)
│
├── dotfiles/              # Mutable desktop dotfiles (symlinked via Home Manager)
└── certs/                 # Local CA certificates (not meant for public reuse)
```

---

## Hosts

| Host         | Type     | Profile          | Description                                                              |
| ------------ | -------- | ---------------- | ------------------------------------------------------------------------ |
| **grospc**   | Desktop  | `workstation`    | Primary workstation with Zen kernel, COSMIC DE, gaming optimizations     |
| **minipc**   | Server   | `homelab-master` | Homelab server running all services (monitoring, DNS, reverse proxy, AI) |
| **minidesk** | Portable | `workstation`    | Travel workstation with Zen kernel, COSMIC DE (no NFS mounts)            |

---

## Key Design Principles

### 1. Snowfall-driven architecture

`snowfall-lib` is used to:

- Auto-discover systems, homes, and modules
- Enforce namespacing (`bigor.*`)
- Reduce boilerplate in `flake.nix`

This keeps the flake concise while allowing deep modularity.

### 2. Profile-based configuration

High-level profiles toggle entire feature sets:

- `bigor.profiles.workstation`
  - A comprehensive desktop environment
  - PipeWire audio
  - Fonts and GUI apps
  - Gaming optimizations

- `bigor.profiles.homelab-master`
  - SSH, Tailscale
  - Unbound+Blocky DNS stack (recursive resolver + ad blocking)
  - Caddy reverse proxy
  - Prometheus / Grafana / Alertmanager
  - Ollama AI backend
  - NFS server

Profiles only enable _defaults_; everything remains overridable per host.

### 3. Network Topology (SSOT)

All network services and hosts are centrally defined in `modules/nixos/lib/network-topology/`. This **Single Source of Truth** approach:

- Defines host IPs and interfaces once
- Declares services with their exposure settings (DNS, Caddy, firewall)
- Each module (Caddy, Blocky, firewall) reads the topology directly and auto-configures itself

**Architecture:**

```
network-topology (SSOT)
        ↓
   ├─→ Caddy (generates reverse proxy for local services)
   ├─→ Firewall (opens ports for local services)
   └─→ Blocky (generates DNS rewrites for all services)
```

Adding a new service is as simple as:

```nix
myservice = {
  host = "minipc";
  port = 8080;
  domain = "myservice.bigor.lan";
  expose = { dns = true; reverseProxy = true; firewall = false; };
};
```

**Benefits:**

- No intermediate "consumer" layer - direct topology consumption
- Configuration visible where it's applied
- Easy to debug and customize per module

### 4. Modular DNS Stack (Blocky + Unbound)

The DNS infrastructure supports **3 independent deployment patterns**:

#### Pattern 1: Full Stack (minipc)

Blocky + Unbound running locally:

```nix
bigor.services.blocky.enable = true;  # upstreamMode = "unbound-local" (default)
bigor.services.unbound = {
  enable = true;
  listenOnLan = true;  # Allow other hosts to use this Unbound
};
```

#### Pattern 2: Remote Unbound (grospc)

Blocky forwards to Unbound on another host:

```nix
bigor.services.blocky = {
  enable = true;
  upstreamMode = "unbound-lan";
  upstreamHost = "minipc";  # Use minipc's Unbound instance
};
```

#### Pattern 3: Standalone (minidesk)

Blocky with external DNS upstreams (no Unbound):

```nix
bigor.services.blocky = {
  enable = true;
  upstreamMode = "external";
  externalUpstreams = [ "1.1.1.1" "1.0.0.1" ];  # Cloudflare (default)
};
```

**Features:**

- Ad/tracker blocking via Blocky (multiple curated blocklists)
- DNSSEC validation via Unbound
- Auto-generated DNS rewrites from network topology
- Prometheus metrics for monitoring
- ~60% faster than AdGuard Home

### 5. Home Manager as a first-class citizen

User environments are:

- Fully declarative
- Host-aware (`user@host`)
- Split into reusable modules (shell, git, CLI tools, GUI apps, Neovim)

The Neovim configuration is 100% Nix, powered by **nixvim**, and includes:

- LSP, Treesitter, formatting, diagnostics
- Opinionated defaults for modern development

---

## Prerequisites

- **NixOS** with flakes enabled
- **Git** for cloning the repository

To enable flakes, add to your `/etc/nixos/configuration.nix`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

---

## Quick Start

```bash
# Clone the repository
git clone https://github.com/bigor44/nixos.git
cd nixos

# Build and switch (using nh helper - recommended)
nh os switch  # Automatically detects hostname

# Or using nixos-rebuild directly
sudo nixos-rebuild switch --flake .#<hostname>

# Format all files
nix fmt

# Run quality checks (recommended before flake check)
statix check  # Nix linting
deadnix       # Dead code detection

# Run all checks (includes formatting verification)
nix flake check
```

Replace `<hostname>` with `grospc`, `minipc`, or `minidesk`.

---

## Code Quality & Tooling

The flake includes automated checks:

- **statix** – Nix linting and best practices
- **deadnix** – Detection of unused code
- **treefmt** – Formatting verification (nixfmt, shfmt, prettier, taplo)

**Recommended workflow:**

```bash
# 1. Format all files
nix fmt

# 2. Check for style issues
statix check

# 3. Check for dead code
deadnix

# 4. Run full validation (includes build checks)
nix flake check
```

This order ensures formatting and style issues are caught early, before the more expensive build validation.

---

## Secrets Management

This repository integrates **sops-nix**.

Secrets are expected to be:

- Encrypted with `age`
- Decrypted at build time
- Never committed in plaintext

> Note: secret files and private keys are intentionally excluded from this repository.

---

## Dependencies

This configuration is built on top of these excellent projects:

| Project                                                       | Purpose                                     |
| ------------------------------------------------------------- | ------------------------------------------- |
| [nixpkgs](https://github.com/NixOS/nixpkgs)                   | Core NixOS packages (unstable branch)       |
| [snowfall-lib](https://github.com/snowfallorg/lib)            | Opinionated flake structure and namespacing |
| [home-manager](https://github.com/nix-community/home-manager) | Declarative user environment management     |
| [nixvim](https://github.com/nix-community/nixvim)             | 100% Nix-based Neovim configuration         |
| [sops-nix](https://github.com/Mic92/sops-nix)                 | Secrets management with age encryption      |

---

## What This Is (and Is Not)

**This is:**

- A real-world NixOS setup used daily
- A reference architecture for modular flakes
- A strong starting point for homelab + workstation setups

**This is not:**

- A beginner tutorial
- A minimal configuration
- A generic, one-size-fits-all flake

---

## License

MIT License.

You are free to use, modify, and redistribute this configuration. Attribution is appreciated but not required.

---

## Author

**Yoann Bigor**

If you find this repository useful or inspiring, feel free to fork it or open a discussion.
