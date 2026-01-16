# Contributing to Bigor's NixOS Configuration

First off, thank you for considering contributing to this project! It's people like you that make the open-source community such a great place to learn, inspire, and create.

This document provides guidelines for contributing to this repository. Following these helps ensure a smooth process for everyone.

---

## 🏗️ Project Architecture

Before contributing, please familiarize yourself with the modular structure of this project:

### NixOS Modules

- **Platform Modules (`modules/nixos/platform/`)**: Mandatory infrastructure (boot, network, users, etc.). These modules do NOT have `enable` options and are always active.
- **Feature Modules (`modules/nixos/features/`)**: Optional features (gaming, desktop, etc.) that must be explicitly enabled in host configurations via `bigor.features.<name>.enable`.

### Home Manager Modules

Home Manager follows the same **Platform vs. Features** pattern:

- **Platform Modules** (always active):
  - `shell/` - Zsh with Starship, fzf, zoxide, and bat
  - `git.nix` - Git configuration and aliases
  - `cli-tools.nix` - Essential CLI tools (eza, fd, ripgrep, btop, etc.)

- **Feature Modules** (optional, require `bigor.home.<name>.enable = true`):
  - `nixvim/` - Neovim with LSP and plugins
  - `dev-tools.nix` - Development tools (statix, deadnix, lazygit, claude-code, etc.)
  - `dev-scripts.nix` - QA scripts (check-quick, check-full, dns-test, etc.)
  - `gui.nix` - Desktop applications
  - `wallpapers.nix` - Wallpaper synchronization

### Host Definitions

- **Host Configurations (`hosts/`)**: Specific configurations for each machine.

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

- **Feature Modules**:
  - **NixOS features** (`modules/nixos/features/`) must follow the standard template:
    - Define an `enable` option under `bigor.features.<name>.enable`.
    - Wrap the configuration in `mkIf cfg.enable`.
    - Reference `modules/nixos/features/gaming.nix` for a clean example.
  - **Home Manager features** (`modules/home/`) that are optional must:
    - Define an `enable` option under `bigor.home.<name>.enable`.
    - Wrap the configuration in `mkIf cfg.enable`.
    - Reference `modules/home/dev-tools.nix` or `modules/home/gui.nix` for examples.
  - **Platform modules** (both NixOS and Home Manager) do NOT have enable options and are always active.
- **Shell Scripts**:
  - Must start with a minimal header: Shebang + Script Name + Purpose.
  - Avoid large ASCII banners.
  - Apply the same "Why, not What" commenting rule as Nix files.
- **Comments**:
  - Must be in **English**.
  - Should be **useful** and explain the **why** (intent), not the **what** (code is self-documenting).
  - Use sparingly.
  - **Anti-patterns** (Avoid these):
    - _Bad:_ `# Enable steam` -> `programs.steam.enable = true;` (Redundant)
    - _Good:_ `# Required for Proton compatibility` -> `programs.steam.enable = true;` (Adds context)

- **`inherit` Pattern**:
  - Only use `inherit (lib)` when you have **3 or more** usages of lib functions.
  - For 1-2 usages, prefix directly with `lib.` (e.g., `lib.mkEnableOption`, `lib.mkIf`).
  - **Why:** The `inherit` pattern reduces verbosity but adds cognitive overhead. For few usages, direct prefixing is clearer.
  - **Examples**:
    - Good (3+ usages): `inherit (lib) mkEnableOption mkIf mkOption types;`
    - Bad (only 2 usages): `inherit (lib) mkEnableOption mkIf;`
    - Better: Use `lib.mkEnableOption` and `lib.mkIf` directly.

### 3. Make Your Changes

- Follow the **Platform vs. Features** pattern (applies to both NixOS and Home Manager modules).
- If adding a new **feature** (optional functionality), ensure it has an `enable` option:
  - NixOS features: `bigor.features.<name>.enable`
  - Home Manager features: `bigor.home.<name>.enable`
- **Platform modules** (mandatory infrastructure) do NOT have enable options.
- Keep host-specific configurations in `hosts/`.
- Use `nix/network-topology.nix` for any new IP or hostname definitions.

- **Firewall Configuration**:
  - **NEVER** add `networking.firewall.*` to feature modules
  - All firewall rules are centralized in `modules/nixos/platform/firewall.nix`
  - When adding a service that needs port openings:
    1. Add port numbers to `nix/network-topology.nix`
    2. Update `modules/nixos/platform/firewall.nix` to include the service
    3. If the service requires a static IP (listening on LAN), add it to the assertions
  - The firewall module automatically opens ports based on enabled features and network topology

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
