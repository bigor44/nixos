# Bigor’s NixOS

A modular, flake-based **NixOS configuration** with a clean separation between **mandatory platform infrastructure** and **optional features**.  
This repository also integrates **Home Manager** and a strict quality-driven development workflow.

<div align="center">

[![CI](https://github.com/bigor44/nixos/actions/workflows/ci.yml/badge.svg)](https://github.com/bigor44/nixos/actions/workflows/ci.yml)
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

</div>

---

## ✨ Highlights

- **Nix Flakes + flake-parts**
- Clear **Platform vs Feature** module architecture
- **Home Manager** for user environments
- Opinionated **developer tooling & QA workflow**
- Fully reproducible and auditable configuration

---

## 📦 Managed Hosts

| Host     | Purpose                         |
| -------- | ------------------------------- |
| `grospc` | Desktop workstation with gaming |

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
└── scripts/                # Utility scripts
```

---

## 🔩 Platform vs Features

### Platform Modules (`modules/nixos/platform/`)

- Always enabled
- No `enable` options
- Core infrastructure (users, network, locale, packages, etc.)

### Feature Modules (`modules/nixos/features/`)

- Optional and explicitly enabled per host
- Controlled via:

  ```nix
  bigor.features.<category>.<name>.enable = true;
  ```

- Examples:
  - `graphics.desktop`
  - `graphics.gaming`
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

## 📂 Dotfiles

The `dotfiles/` directory contains raw configuration files for various applications, which are deployed via Home Manager.

| File/Directory | Description                                                      |
| -------------- | ---------------------------------------------------------------- |
| `autostart/`   | `.desktop` files for applications that should launch on startup. |
| `cosmic/`      | Configuration files for the Cosmic desktop environment.          |
| `nvim/`        | Neovim configuration files.                                      |

---

## Utility Scripts

This repository includes several utility scripts in the `scripts/` directory to aid in development and maintenance:

| Script             | Description                                                                                        |
| ------------------ | -------------------------------------------------------------------------------------------------- |
| `concat_config.sh` | Aggregates all configuration files into a single Markdown document for easy sharing and review.    |
| `post_install.sh`  | Automates the initial setup of a new host by copying hardware configs and updating state versions. |

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
