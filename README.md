<!--
 ============================================================================
 File: README.md
 Description: Main documentation for the NixOS configuration.
 Author: Bigor
 Date: 2025-12-18
 Purpose: Provides a high-level overview of the project, its structure,
          and how to use it.
 ============================================================================
-->

# Bigor NixOS Configuration

A modular, opinionated, and production-ready **NixOS + Home Manager** configuration built with **Flakes** and **snowfall-lib**.

This repository is designed to be:

- **Reproducible**: fully declarative system and user environments
- **Modular**: clean separation of concerns (profiles, services, homes, modules)
- **Scalable**: supports multiple hosts and profiles from a single codebase
- **Open-source friendly**: readable structure, documented intent, and sane defaults

---

## Overview

This flake manages:

- Multiple NixOS hosts (desktop + homelab)
- Per-host Home Manager configurations
- A fully declarative Neovim setup via **nixvim**
- Desktop (COSMIC) and headless server profiles
- Homelab services (AdGuard, Caddy, Prometheus, Grafana, Ollama, NFS, etc.)

The configuration heavily relies on **snowfall-lib** to enforce a consistent layout and naming scheme.

---

## Repository Structure

```
.
├── flake.nix              # Flake entry point
├── flake.lock             # Locked dependencies
├── checks/                # CI-style checks (statix, deadnix)
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
│       └── services/      # Declarative services (AdGuard, Caddy, Monitoring, etc.)
│
├── dotfiles/              # Mutable desktop dotfiles (symlinked via Home Manager)
└── certs/                 # Local CA certificates (not meant for public reuse)
```

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
  - AdGuard Home
  - Caddy reverse proxy
  - Prometheus / Grafana / Alertmanager
  - Ollama AI backend
  - NFS server

Profiles only enable _defaults_; everything remains overridable per host.

### 3. Home Manager as a first-class citizen

User environments are:

- Fully declarative
- Host-aware (`user@host`)
- Split into reusable modules (shell, git, CLI tools, GUI apps, Neovim)

The Neovim configuration is 100% Nix, powered by **nixvim**, and includes:

- LSP, Treesitter, formatting, diagnostics
- Opinionated defaults for modern development

---

## Supported Systems

- `x86_64-linux`

The configuration currently targets NixOS unstable.

---

## Usage

### Clone the repository

```bash
git clone https://github.com/bigor44/nixos.git
cd nixos
```

### Build or switch a system

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

---

## Code Quality & Tooling

The flake includes automated checks:

- **statix** – Nix linting and best practices
- **deadnix** – detection of unused code

Run them with:

```bash
nix flake check
```

Formatting is handled by `treefmt` and can be applied by running `nix fmt`.

It uses `nixfmt-rfc-style`, `prettier`, `stylua`, and other tools.

---

## Secrets Management

This repository integrates **sops-nix**.

Secrets are expected to be:

- Encrypted with `age`
- Decrypted at build time
- Never committed in plaintext

> Note: secret files and private keys are intentionally excluded from this repository.

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
