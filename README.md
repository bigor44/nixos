# ❄️ Bigor's NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg)](https://github.com/nixos/nixpkgs)
[![Flakes](https://img.shields.io/badge/Nix-Flakes-7e57c2.svg)](https://nixos.wiki/wiki/Flakes)
[![Sops-Nix](https://img.shields.io/badge/Secrets-Sops-green.svg)](https://github.com/Mic92/sops-nix)

A **declarative, reproducible, and role-based** NixOS configuration managing a desktop and a homelab server. Built with Flakes, Home Manager, Sops-nix, and **nh**.

---

## 🏗️ Architecture

This configuration uses a **Capability-based** design pattern. Hosts are assigned a `role` (desktop/server), which triggers specific capability flags (`desktop.enable`,  etc.).



```mermaid
graph TD
    subgraph Hosts
        G[Grospc (Desktop)]
        M[Minipc (Server)]
    end

    subgraph Core
        F[Flake.nix]
        HM[Home Manager]
        SOPS[Sops Secrets]
    end

    subgraph Roles
        RD[Role: Desktop]
        RS[Role: Server]
    end

    subgraph Services
        Mon[Monitoring Stack]
        AGH[AdGuard Home]
        Rev[Caddy Proxy]
        Dash[Homepage]
    end

    F --> G & M
    G --> RD
    M --> RS
    RD --> HM
    RS --> Mon & AGH & Rev & Dash
````

-----

## 🖥️ Hosts Overview

| Host | IP | Role | Kernel | Key Features |
| :--- | :--- | :--- | :--- | :--- |
| **`grospc`** | `192.168.1.11` | `desktop` | `linuxPackages_zen` | Cosmic DE, Plasma 6, Steam, Gaming optimization, NFS Client |
| **`minipc`** | `192.168.1.10` | `server` | `linuxPackages_latest` | 24/7 Services, NFS Server, Tailscale Exit Node, Monitoring Hub |

-----

## ✨ Key Features

### 🎨 Desktop & Environment (Grospc)

  * **Desktop Environment**: Dual setup with **Cosmic Desktop** (Alpha) and **KDE Plasma 6**.
  * **Gaming**: Steam, Gamemode, and optimized scheduler parameters (`performance` governor).
  * **Terminal**: **Alacritty** with Catppuccin Mocha theme.
  * **Fonts**: Priority management for **Nerd Fonts** (JetBrainsMono) with full CJK and Emoji fallback support.
  * **Audio**: Pipewire with low-latency configuration.

### 🏠 Homelab Services (Minipc)

The server acts as a central hub reachable via local domains (`*.bigor.lan`) managed by AdGuard and Caddy.

| Service | Local Domain | Description |
| :--- | :--- | :--- |
| **Homepage** | `home.bigor.lan` | Central dashboard with live widgets. |
| **AdGuard Home** | `adguard.bigor.lan` | Network-wide ad blocking & DNS rewriting. |
| **Grafana** | `grafana.bigor.lan` | Visualization for Prometheus metrics. |
| **Alertmanager** | `alerts.bigor.lan` | Alert routing (integrated into Homepage). |
| **Vaultwarden** | `vault.bigor.lan` | Self-hosted password manager. |

  * **Reverse Proxy**: **Caddy** handles internal TLS certificates automatically.
  * **NFS**: Server hosts `/mnt/storage`, automatically mounted by the Desktop client.
  * **Tailscale**: Configured as an **Exit Node** with UDP GRO forwarding optimizations.

### 🛠️ Development & Dotfiles

  * **Neovim**: Fully configured via Lua (Lazy.nvim, LSP, Treesitter, Catppuccin).
  * **Shell**: **Fish** shell paired with **Starship** prompt.
  * **Dev Workflow**: Dotfiles (`nvim`, `cosmic`, `autostart`) are linked via `mkOutOfStoreSymlink` for live editing.

-----

## 🚀 Quick Start

### 1\. Prerequisites

  * A machine running NixOS.
  * **Git** installed.
  * **SSH Keys** generated for the machine.

### 2\. Installation

Clone the repository to the home directory (Important for `nh` config):

```bash
git clone [https://github.com/yourusername/nixos-config](https://github.com/yourusername/nixos-config) ~/nixos
cd ~/nixos
```

### 3\. Secrets

This config uses **sops-nix**. You must have the correct Age key in `~/.config/sops/age/keys.txt` or the SSH host key to decrypt `secrets/secrets.yaml`.

### 4\. Deploy with `nh`

This configuration includes **nh (Nix Helper)** for faster and prettier deployments.

**Apply configuration to the current machine:**

```bash
nh os switch
```

**Apply configuration to a specific host (e.g., server):**

```bash
nh os switch -H minipc
```

> **Note:** If `nh` is not installed yet (first run), use the standard command:
> `sudo nixos-rebuild switch --flake .#<hostname>`

-----

## 🧰 Maintenance

### Updating the System

Update flake inputs (nixpkgs, etc.) and apply the new configuration in one go:

```bash
# Update and switch
nh os switch --update
```

### Cleaning Up

Garbage collect old generations using `nh` (cleaner and safer than standard nix-collect-garbage):

```bash
# Keep the last 3 generations and everything from the last 4 days
nh clean all --keep 3 --keep-since 4d
```

### Formatting Code

Pre-commit hooks are configured (`nixfmt`, `stylua`, `statix`, `deadnix`).

```bash
nix develop
pre-commit run --all-files
```

-----

## 📜 License

MIT

```
