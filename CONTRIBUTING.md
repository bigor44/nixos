# Contributing to Bigor's NixOS Configuration

First off, thank you for considering contributing to this project! It's people like you that make the open-source community such a great place to learn, inspire, and create.

This document provides guidelines for contributing to this repository. Following these helps ensure a smooth process for everyone.

---

## 🏗️ Project Architecture

Before contributing, please familiarize yourself with the modular structure of this project:

- **Platform Modules (`modules/nixos/platform/`)**: Mandatory infrastructure (boot, network, users, etc.).
- **Feature Modules (`modules/nixos/features/`)**: Optional features (gaming, desktop, etc.) that must be explicitly enabled in host configurations.
- **Home Manager Modules (`modules/home/`)**: User-specific configurations.
- **Host Definitions (`hosts/`)**: Specific configurations for each machine.

## 🚀 Getting Started

### Prerequisites

- **NixOS** with **Flakes** and **Nix Command** enabled.
- **Git** installed.

### Development Environment

Always use the provided development shell to ensure you have all the necessary tools (like `nh`, `sops`, `statix`, `deadnix`, etc.):

```bash
git clone https://github.com/bigor44/nixos.git
cd nixos
nix develop
```

This will automatically set up pre-commit hooks and provide useful aliases.

## 🛠️ Development Workflow

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Coding Standards

To maintain consistency across the codebase, please follow these standards:

- **File Header**: Every Nix file must start with a 2-line header. The first line should use a prefix that identifies the file's category, followed by a `# Purpose:` line:
  - `# Feature:` for system features or platform modules (`modules/nixos/`).
  - `# Module:` for shared home manager modules (`modules/home/`).
  - `# Home:` for specific user environments or NixVim components (`modules/home/nixvim/`, `hosts/*/home.nix`).
  - `# Host:` for host-specific configurations (`hosts/*/default.nix`).
  - `# Policy:` for system-wide policies (`modules/nixos/platform/policies/`).

  Example:

  ```nix
  # Feature: audio
  # Purpose: PipeWire audio stack with ALSA and PulseAudio compatibility
  ```

- **Feature Modules**: Modules in `modules/nixos/features/` must follow the standard template:
  - Define an `enable` option under `bigor.features.<name>.enable`.
  - Wrap the configuration in `mkIf cfg.enable`.
  - Reference `modules/nixos/features/gaming.nix` for a clean example.
- **Comments**:
  - Must be in **English**.
  - Should be **useful** and explain the **why** (intent), not the **what** (code is self-documenting).
  - Use sparingly.

### 3. Make Your Changes

- Follow the **Platform vs. Capabilities** pattern.
- If adding a new capability, ensure it has an `enable` option.
- Keep host-specific configurations in `hosts/`.
- Use `nix/network-topology.nix` for any new IP or hostname definitions.

### 4. Formatting and Linting

We enforce strict formatting and linting rules:

- **Format**: Run `nix fmt` to format all files using `treefmt`.
- **Lint**: Run `statix check .` and `deadnix .` to check for common mistakes and dead code.

### 5. Testing Your Changes

Before committing, ensure your changes don't break the configuration:

- **Quick Check**: Run `check-quick` (or `qc`) for a fast incremental check.
- **Full Check**: Run `check-full` (or `qf`) for a complete validation of all hosts.
- **Intelligent Check**: Run `check-mega` (or `mega`) to automatically choose the best check based on git state.
- **DNS Test**: If you modified DNS settings, run `dns-test`.

### 6. Applying Changes Locally

To test your changes on your current machine:

```bash
nhs  # nh os switch . (rebuild and switch)
# OR
nhb  # nh os boot . (rebuild and set as boot entry)
```

## 📝 Commit Guidelines

We use a safe commit workflow. It's highly recommended to use the `gcn` alias:

```bash
gcn -m "feat: add new capability for X"
```

The `gcn` alias will:

1. Format your code.
2. Stage all changes.
3. Run all checks.
4. Prompt for a commit message (if not provided via `-m`).
5. Only commit if all checks pass.

## 🔐 Secrets Management

Do **NOT** commit plain-text secrets. This project uses **SOPS** with **age**.

- To edit secrets: `sops secrets/secrets.yaml`
- New secrets should be added to `secrets/secrets.yaml` and referenced in your Nix modules via `config.sops.secrets`.

## 🤝 Pull Request Process

1. Ensure all checks pass (`check-full`).
2. Update the `README.md` if you've added new features or changed existing ones.
3. Push your branch to your fork.
4. Open a Pull Request with a clear description of the changes.

---

Thank you for your contribution!
