# Bigor’s NixOS Configuration

A modular, flake-based **NixOS configuration** used to manage multiple machines with a clean separation between **mandatory platform infrastructure** and **optional features**.  
This repository also integrates **Home Manager**, **SOPS**, and a strict quality-driven development workflow.

---

## ✨ Highlights

- **Nix Flakes + flake-parts**
- Clear **Platform vs Feature** module architecture
- **Multi-host** setup (desktop, portable workstation, homelab)
- **Home Manager** for user environments
- **SOPS + age** for secrets management
- Opinionated **developer tooling & QA workflow**
- Fully reproducible and auditable configuration

---

## 📦 Managed Hosts

| Host       | Purpose                                              |
| ---------- | ---------------------------------------------------- |
| `grospc`   | Desktop workstation with gaming                      |
| `minidesk` | Portable workstation                                 |
| `minipc`   | Homelab server (DNS, reverse proxy, monitoring, NFS) |

Each host lives in `hosts/<hostname>/configuration.nix` and only enables the features it needs.

---

## 🧱 Architecture Overview

### High-Level Structure

```text
.
├── flake.nix               # Flake entry point (flake-parts)
├── hosts/                  # Per-machine configurations
├── modules/
│   ├── nixos/
│   │   ├── platform/       # Mandatory system infrastructure
│   │   └── features/       # Optional, toggleable capabilities
│   └── home/               # Home Manager modules
├── nix/                    # Flake wiring (hosts, devshell, hooks)
├── secrets/                # SOPS-encrypted secrets
├── scripts/                # Utility scripts
└── certs/                  # Certificates
```

---

## 🔩 Platform vs Features

### Platform Modules (`modules/nixos/platform/`)

- Always enabled
- No `enable` options
- Core infrastructure (users, network, locale, packages, SOPS, etc.)

### Feature Modules (`modules/nixos/features/`)

- Optional and explicitly enabled per host
- Controlled via:

  ```nix
  bigor.features.<category>.<name>.enable = true;
  ```

- Examples:
  - `graphics.desktop`
  - `graphics.gaming`
  - `dev.nixvim`
  - `services.blocky`
  - `services.caddy`
  - `monitoring.grafana`
  - `hardware.audio`

### Home Manager (`modules/home/`)

- User-level configuration
- Dotfiles, shell, apps, Git config
- Automatically follows enabled system features (e.g. desktop)

---

## 🚀 Getting Started

### Prerequisites

- NixOS with:
  - `nix-command`
  - `flakes`

- Git

### Clone the Repository

```bash
git clone https://github.com/bigor44/nixos.git
cd nixos
```

### Enter the Development Shell (Recommended)

```bash
nix develop
```

This provides:

- `nixos-rebuild`
- `sops`
- `treefmt`, `statix`, `deadnix`, `shellcheck`
- Preconfigured aliases and pre-commit hooks

---

## 🔁 Common Commands

| Command   | Description                             |
| --------- | --------------------------------------- |
| `qc`      | Quick formatting & linting (pre-commit) |
| `qf`      | Full validation (`nix flake check`)     |
| `nrs`     | Rebuild and switch system               |
| `nrb`     | Rebuild and apply on next boot          |
| `nix fmt` | Format entire repository                |

---

## 🔐 Secrets Management

Secrets are managed using **SOPS + age**.

- Encrypted file: `secrets/secrets.yaml`
- Edit secrets:

  ```bash
  sops secrets/secrets.yaml
  ```

- Access secrets in Nix via:

  ```nix
  config.sops.secrets.<name>
  ```

**Never commit plaintext secrets.**

---

## 🧪 Quality & Safety

This repository enforces strict quality controls:

- Formatting via `treefmt`
- Static analysis via `statix` and `deadnix`
- Shell validation via `shellcheck`
- Safe commit & push workflow

Before committing:

```bash
qc
```

Before pushing:

```bash
qf
```

---

## 🤝 Contributing

Contributions are welcome.

Please read **[`CONTRIBUTING.md`](./CONTRIBUTING.md)** for:

- Architectural rules
- Coding conventions
- Feature module templates
- Commit and PR guidelines

---

## 📜 License

This project is licensed under the terms of the **MIT License**.
See [`LICENSE`](./LICENSE) for details.

---

## 📎 Notes

This repository is intentionally opinionated.
It prioritizes **clarity, reproducibility, and long-term maintainability** over minimalism.

Feel free to fork and adapt it to your own infrastructure.

```

```
