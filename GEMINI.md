# GEMINI.md - Context & Instructions

## 1. Project Overview

This repository is a **modular NixOS configuration** managed with **Flakes** and **Home Manager**. It manages the system state for multiple machines (desktop, server, laptop) and user environments.

**Key Technologies:**

- **NixOS Flakes:** Core configuration management.
- **Home Manager:** User environment management (integrated via NixOS modules).
- **flake-parts:** Flake structuring library.
- **nh (Nix Helper):** CLI tool for faster/safer rebuilds.
- **SOPS + age:** Secret encryption.
- **COSMIC DE:** The primary desktop environment.
- **NixVim:** Neovim configuration managed via Nix.

## 2. Architecture & Patterns

### Module System

The configuration distinguishes between **Platform** and **Capabilities**:

- **`modules/nixos/platform/`**: Mandatory infrastructure modules included in every host (boot, network, users, sops, basic policies).
- **`modules/nixos/features/`**: Optional features (gaming, desktop, specific services) that must be explicitly enabled in host configs (e.g., `features.gaming.enable = true;`).

### Host Definitions (`nix/hosts.nix`)

Hosts are defined programmatically using a `mkHost` function which:

1.  Imports common NixOS/Home Manager modules.
2.  Imports the specific host configuration (`hosts/<hostname>/default.nix`).
3.  Sets up the `bigor` user via Home Manager.

### Network Topology (`nix/network-topology.nix`)

Central source of truth for IP addresses, domain names, and interface names. This is injected into modules as `specialArgs.networkTopology`.

## 3. Operational Guide

### 🛠 Building & Switching

**Do not use standard `nixos-rebuild` commands directly if possible.** Use the `nh` tool aliases provided in the devshell.

- **Apply Configuration:**
  ```bash
  nhs  # Equivalent to: nh os switch .
  ```
- **Boot Configuration (No switch):**
  ```bash
  nhb  # Equivalent to: nh os boot .
  ```

### 🧪 Validation & Quality Assurance

This project enforces strict quality gates.

- **Quick Check (Incremental):** `check-quick` or `qc`
- **Full Check (CI-equivalent):** `check-full` or `qf`
- **Intelligent Check:** `check-mega` or `mega` (Adapts to git state)
- **Format Code:** `nix fmt` (Uses treefmt)

* **Lint Code:** `statix check .` and `deadnix .`

### 🔐 Secrets Management

Secrets are stored in `secrets/secrets.yaml` and encrypted with **SOPS**.

- **Edit Secrets:** `sops secrets/secrets.yaml`
- **View Decrypted:** `sops -d secrets/secrets.yaml`

### 💻 Development Workflow

Always work inside the devshell (`nix develop`) which provides necessary tools and aliases.

**Coding Standards:**

- **Headers:** All .nix files must have a 2-line header (`# Feature/Module: ...`, `# Purpose: ...`).

- **Capabilities:** Must follow the standard template (enable option, mkIf).

- **Comments:** English only, explain "why" not "what".

**Safe Commit Workflow (`gcn` alias):**

1.  Formats code.

2.  Stages changes.
3.  Runs checks.
4.  Commits only if checks pass.

## 4. Directory Structure

- **`dotfiles/`**: Static configuration files (COSMIC, autostart) symlinked by Home Manager.
- **`hosts/`**: Host-specific `default.nix` and `hardware-configuration.nix`.
- **`modules/nixos/`**: System-level modules (`platform`, `features`).
- **`modules/home/`**: User-level modules (`cli`, `gui`, `nixvim`, `shell`).
- **`nix/`**: Flake logic (`hosts.nix`, `devshell.nix`, `network-topology.nix`).
- **`pkgs/`**: Custom packages (if any).
- **`secrets/`**: Encrypted `secrets.yaml`.

## 5. Host Context

- **`grospc`**: High-performance Desktop. Uses Zen kernel, LAN recursive DNS, NFS client.
- **`minipc`**: Home Server. Uses LTS kernel, Local recursive DNS, NFS server, Caddy, Unbound, Gatus.
- **`minidesk`**: Laptop. Uses Zen kernel, Portable DNS, local storage.
