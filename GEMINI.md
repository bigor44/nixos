# Bigor's NixOS Flake Configuration - Context

This document provides context for the AI agent (Gemini) regarding the structure, roles, and commands of this NixOS configuration repository.

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs (Nixpkgs, Home Manager) and outputs (System Configurations).
- **`hosts/`**: Machine-specific configurations.
  - **`grospc/`**: High-performance Desktop.
    - **Channel**: `nixos-25.11` (Stable)
    - **Key Modules**: `roles.desktop` (COSMIC), `nfs.client`, `sshd.enable`.
    - **Hardware**: AMD CPU/GPU, Zen Kernel.
  - **`minipc/`**: Home Server / Lab.
    - **Channel**: `nixos-25.11` (Stable)
    - **Key Modules**: `roles.homelab_master` (Headless), `nfs.server`, `sshd.enable`.
    - **Networking**: Tailscale optimization (UDP GRO enabled).
- **`modules/`**: Reusable configuration logic.
  - **`nixos/`**: System-level modules (root).
    - **`core/`**: System defaults, locale, users, `options.nix` (feature flags).
    - **`desktop/`**: GUI environment (COSMIC), Audio (Pipewire), Fonts, Gaming.
    - **`services/`**: NFS, Tailscale, SSH, AdGuard, Caddy, Dashboard.
  - **`home/`**: User-level modules (Home Manager for user `bigor`).
    - **`dotfiles.nix`**: Symlink management for files in `dotfiles/`.
    - **`packages.nix`**: User CLI/GUI packages.
    - **`shell.nix`**: Shell configuration (Fish, Starship, tools).
- **`dotfiles/`**: Raw config files (symlinked).
  - `cosmic/`, `nvim/`, `autostart/`.
- **`scripts/`**: Utility scripts (e.g., `concat_config.sh`).

## Custom Options API (`modules/nixos/core/options.nix`)

These options act as high-level feature flags.

| Option                     | Description                                                                      |
| :------------------------- | :------------------------------------------------------------------------------- |
| **`roles.desktop`**        | Enables full graphical environment (COSMIC), audio, fonts, and workstation apps. |
| **`roles.homelab_master`** | Enables headless server services, container orchestration, and monitoring.       |
| **`sshd.enable`**          | Enables hardened OpenSSH server (no root login, key-based auth).                 |
| **`nfs.server`**           | Exports `/mnt/storage` via NFS.                                                  |
| **`nfs.client`**           | Mounts the shared NFS storage.                                                   |
| **`myNetwork.ips`**        | Defines static IPs for `grospc` and `minipc`.                                    |

## Development Workflow

### 1. Apply Changes

Use `nh` for best results.

```bash
nh os switch              # Apply to current host
nh os switch -H minipc    # Apply to remote host
```

### 2. Dependency Management

```bash
nix flake update          # Update lockfile
```

### 3. Code Quality

**ALWAYS** run before committing:

```bash
nix develop               # Enter dev shell
treefmt                   # Format code
nix build .#checks.x86_64-linux.pre-commit-check # Run linters
```
