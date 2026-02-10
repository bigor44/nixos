# Contributing to Bigor's NixOS

First off, thank you for considering contributing to this project! It's people like you that make the open-source community such a great place to learn, inspire, and create.

This document provides guidelines for contributing to this repository. Following these helps ensure a smooth process for everyone.

---

## 🏗️ Project Architecture

Before contributing, please familiarize yourself with the modular structure of this project:

### NixOS Modules

- **Platform Modules (`modules/nixos/platform/`)**: Mandatory infrastructure (boot, network, shell, users, etc.). These modules do NOT have `enable` options and are always active.
- **Feature Modules (`modules/nixos/features/`)**: Optional features (gaming, desktop, dev-tools, etc.) that must be explicitly enabled in host configurations via `bigor.features.<category>.<name>.enable`.
- **Home Modules (`modules/home/`)**: User-specific configuration (dotfiles, shell aliases, applications) managed by **Home Manager**.

### Host Definitions

- **Host Configurations (`hosts/`)**: Specific configurations for each machine.

## 🚀 Getting Started

### Prerequisites

- **NixOS** with **Flakes** and **Nix Command** enabled.
- **Git** installed.

### Development Environment

Always use the provided development shell to ensure you have all the necessary tools (like `nixos-rebuild`, `sops`, `statix`, `deadnix`, `shellcheck`, etc.):

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
- `# Platform:` for core infrastructure (`modules/nixos/platform/`).
- `# Feature:` for optional capabilities (`modules/nixos/features/`).

  Example:

  ```nix
  # Feature: audio
  # Purpose: PipeWire audio stack with ALSA and PulseAudio compatibility
  ```

- **Naming Conventions**:
  - `default.nix`: Reserved for aggregator files (importing multiple files in a directory).
  - `configuration.nix`: Reserved EXCLUSIVELY for host-level entry points in `hosts/*/`.
  - **Descriptive Naming**: Use descriptive names for files with significant logic (e.g., `settings.nix`, `manager.nix`, `home.nix`).
  - **No Redundancy**: Avoid `default.nix` if it simply imports a single file; import that file directly instead.

- **Variable Usage**:
  - Inline variables that are used only once, unless they significantly improve readability or are used for complex expressions.

- **Feature Modules**:
  - **NixOS features** (`modules/nixos/features/`) must follow the standard template:
    - Define an `enable` option under `bigor.features.<category>.<name>.enable`.
    - Wrap the configuration in `mkIf cfg.enable`.
    - Reference `modules/nixos/features/graphics/gaming.nix` for a clean example.
  - **Platform modules** do NOT have enable options and are always active.
- **Home Modules**:
  - Located in `modules/home/`.
  - Primary entry point is `modules/home/home.nix`.
  - Used for user-specific packages, dotfiles, and services.
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

### 3. Make Your Changes

- Follow the **Platform vs. Features** pattern.
- If adding a new **feature** (optional functionality), ensure it has an `enable` option under `bigor.features.<category>.<name>.enable`.
- **Platform modules** (mandatory infrastructure) do NOT have enable options.
- Keep host-specific configurations in `hosts/`.

- **Firewall Configuration**:
  - Use standard NixOS options `networking.firewall.allowedTCPPorts` and `networking.firewall.allowedUDPPorts`.
  - Open ports directly in the feature module where the service is defined.
  - Ensure the ports are necessary and documented.

- **Exposing Services via Caddy & DNS**:
  To expose a service with a local domain (e.g., `myservice.bigor.lan`):
  1. **Define the service** in a feature module.
  2. **Use `mkMerge`** to separate the service config, DNS records, and Caddy config.
  3. **Add a DNS record** in `bigor.network.serviceRecords` pointing to the host's IP.
  4. **Configure Caddy** reverse proxy with `tls internal` (conditional on Caddy being enabled).

  **Example:**

  ```nix
  { config, lib, ... }:
  let
    inherit (lib) mkEnableOption mkIf mkMerge;
    cfg = config.bigor.features.services.myservice;
    networkCfg = config.bigor.network;
  in
  {
    options.bigor.features.services.myservice.enable = mkEnableOption "My Service";

    config = mkIf cfg.enable (mkMerge [
      # 1. Service Configuration
      {
        services.myservice.enable = true;
        networking.firewall.allowedTCPPorts = [ 1234 ];
      }

      # 2. DNS Record (myservice.bigor.lan -> host IP)
      {
        bigor.network.serviceRecords = {
          myservice = networkCfg.hosts.${config.networking.hostName};
        };
      }

      # 3. Caddy Reverse Proxy (Conditional)
      (mkIf config.bigor.features.services.caddy.enable {
        services.caddy.virtualHosts."myservice.${networkCfg.domain}".extraConfig = ''
          tls internal
          reverse_proxy 127.0.0.1:1234
        '';
      })
    ]);
  }
  ```

### 4. Formatting and Linting

We enforce strict formatting and linting rules:

- **Format**: Run `nix fmt` to format all files using `treefmt`.
- **Lint**: Run `statix check .`, `deadnix .`, and `git ls-files '*.sh' | xargs shellcheck` to check for common mistakes, dead code, and shell script issues.

### 5. Testing Your Changes

Before committing, ensure your changes don't break the configuration:

- **Quick Check**: Run `qc` (alias for `pre-commit run`) for fast formatting and linting of staged files.
- **Full Check**: Run `qf` (alias for `nix flake check`) for a complete validation of all hosts and builds.
- **DNS Test**: If you modified DNS settings, run `dns-test`.

### 6. Applying Changes Locally

To test your changes on your current machine:

```bash
nrs  # nix flake check && sudo nixos-rebuild switch --flake .
# OR
nrb  # nix flake check && sudo nixos-rebuild boot --flake .
```

## 📝 Commit Guidelines

We use a safe commit workflow. It's highly recommended to use the `gcn` alias:

```bash
gcn -m "feat: add new capability for X"
```

The `gcn` alias will:

1. Stage all changes.
2. Run `pre-commit` checks (linting, formatting).
3. Commit only if checks pass.

To push your changes safely, use `gps`:

```bash
gps
```

This ensures a full flake check passes before pushing to the remote.

## 🔐 Secrets Management

Do **NOT** commit plain-text secrets. This project uses **SOPS** with **age**.

- To edit secrets: `sops secrets/secrets.yaml`
- New secrets should be added to `secrets/secrets.yaml` and referenced in your Nix modules via `config.sops.secrets`.

## 🤝 Pull Request Process

1. Ensure all checks pass (`qf`).
2. Update the `README.md` if you've added new features or changed existing ones.
3. Push your branch to your fork.
4. Open a Pull Request with a clear description of the changes.

---

Thank you for your contribution!
