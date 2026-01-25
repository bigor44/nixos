# Bigor’s NixOS Configuration

This repository contains my **NixOS infrastructure**, managed with **Nix Flakes** and a **strictly modular architecture**.  
It supports multiple hosts (desktop, laptop, homelab server) while maximizing reuse, validation, and long-term maintainability.

The design clearly separates:

- **Mandatory platform infrastructure**
- **Optional features**
- **User (Home Manager) configuration**

---

## ✨ Key Principles

- **Flakes first** – reproducible, declarative, versioned
- **Explicit enablement** – nothing optional is enabled implicitly
- **Strong validation** – assertions, topology checks, flake checks
- **Host clarity** – minimal host files, no hidden logic
- **Single source of truth** – network, ports, services are centralized

---

## 🗂️ Repository Structure

```

.
├── flake.nix                # Flake entry point (flake-parts)
├── flake.lock               # Locked dependencies
├── hosts/                   # Per-machine configurations
├── modules/
│   ├── nixos/
│   │   ├── platform/        # Mandatory system infrastructure (always enabled)
│   │   └── features/        # Optional capabilities (explicitly enabled)
│   └── home/                # Home Manager modules
├── nix/                     # Flake helpers, checks, devshell
├── scripts/                 # Utility scripts
├── secrets/                 # Encrypted secrets (SOPS)
├── dotfiles/                # Desktop environment config (Cosmic)
├── certs/                   # Internal CA certificates
├── CONTRIBUTING.md          # Architecture & contribution rules
└── LICENSE

```

---

## 🧠 Architecture Overview

### 1. Platform Modules (`modules/nixos/platform/`)

- **Always enabled**
- Core OS concerns: boot, users, DNS, networking, firewall, Nix settings
- **No `enable` options by design**

### 2. Features (`modules/nixos/features/`)

Atomic units of configuration that can be enabled or disabled.

- Must expose:

```nix
bigor.features.<category>.<name>.enable
```

- Wrapped in `mkIf cfg.enable`
- Examples:
  - `graphics.desktop`
  - `graphics.gaming`
  - `services.caddy`
  - `dev.nixvim`

### 4. Home Manager (`modules/home/`)

- User-level configuration
- Activated automatically via NixOS integration
- Desktop-only logic can reference `osConfig.bigor.features.*`

---

## 🖥️ Hosts

Each host lives in `hosts/<hostname>/` and contains **only**:

- Host identity
- Feature selection
- Truly host-specific overrides

Examples:

- **`grospc`** – Desktop workstation with gaming
- **`minidesk`** – Portable workstation
- **`minipc`** – Homelab server (DNS, NFS, Caddy, monitoring)

---

## 🌐 Network & Firewall Model

- **All ports are declared centrally** in `nix/network-topology.nix`
- Feature modules **never** touch `networking.firewall.*` directly
- Services declare intent via:

```nix
bigor.network.firewall.ports
bigor.network.requiredStaticIpServices
```

The platform layer:

- Opens ports
- Validates topology
- Enforces consistency

---

## 🔐 Secrets Management

- Managed with **SOPS + age**
- Stored encrypted in `secrets/secrets.yaml`
- Never committed in plain text

```bash
sops secrets/secrets.yaml
```

Accessed via:

```nix
config.sops.secrets.<name>
```

---

## 🛠️ Development Environment

Always use the provided dev shell:

```bash
nix develop
```

### Common Aliases

| Alias | Command                                | Description                                      |
| :---- | :------------------------------------- | :----------------------------------------------- |
| `qc`  | `pre-commit run`                       | **Quick Check**: Lint/format staged files        |
| `qf`  | `nix flake check`                      | **Full Check**: Validate entire configuration    |
| `gcn` | _(sequence)_                           | **Safe Commit**: Add all + Check + Commit        |
| `gps` | _(sequence)_                           | **Safe Push**: Full Check + Push                 |
| `nrs` | `... && sudo nixos-rebuild switch ...` | **Rebuild Switch**: Check + Rebuild current host |
| `nrb` | `... && sudo nixos-rebuild boot ...`   | **Rebuild Boot**: Check + Build for next boot    |

---

## 🚀 Deployment

### Current host

```bash
nrs
```

### Remote host

```bash
nixos-rebuild switch \
  --flake .#<hostname> \
  --target-host user@ip
```

---

## 📐 Conventions

This repository follows **strict structural and naming rules**:

- Mandatory file headers
- Clear separation of concerns
- No hidden enablement
- “Explain **why**, not what” comments only

➡️ **See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for the full specification.**

---

## 📜 License

This project is licensed under the terms of the **MIT License** (see `LICENSE`).

---

## 🧭 Status

This configuration is **actively used and maintained** for personal infrastructure.
Breaking changes are intentional and validated via `nix flake check`.

---
