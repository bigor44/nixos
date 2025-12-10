# Bigor's NixOS Flake Configuration - Context

This document provides context for the AI agent (Gemini) regarding the structure, roles, and commands of this NixOS configuration repository.

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs (Nixpkgs, Home Manager) and outputs (System Configurations).
- **`systems/`**: Machine-specific configurations.
  - **`x86_64-linux/`**:
    - **`grospc/`**: High-performance Desktop.
      - **Channel**: `nixos-25.11` (Stable)
      - **Key Modules**: `bigor.roles.desktop` (COSMIC), `bigor.nfs.client`, `bigor.sshd.enable`.
      - **Hardware**: AMD CPU/GPU, Zen Kernel.
    - **`minipc/`**: Home Server / Lab.
      - **Channel**: `nixos-25.11` (Stable)
      - **Key Modules**: `bigor.roles.homelab_master` (Headless), `bigor.nfs.server`, `bigor.sshd.enable`.
      - **Networking**: Tailscale optimization (UDP GRO enabled).
- **`modules/`**: Reusable configuration logic.
  - **`nixos/`**: System-level modules (root).
    - **`core/`**: System defaults, locale, users, `options.nix` (feature flags).
      - **`nixvim/`**: Neovim configuration (modularized).
    - **`desktop/`**: GUI environment (COSMIC), Audio (Pipewire), Fonts, Gaming.
    - **`services/`**:
      - **Infrastructure**: NFS, Tailscale, SSH.
      - **Applications**: AdGuard, Caddy, Dashboard (Homepage), Glances (Monitoring).
      - **Pattern**: Services are self-contained. They define their own Caddy `virtualHosts` and AdGuard `rewrites` within their own `.nix` file using `services.caddy.virtualHosts` and `services.adguardhome.settings.filtering.rewrites`.
  - **`home/`**: User-level modules (Home Manager for user `bigor`).
    - **`dotfiles.nix`**: Symlink management for files in `dotfiles/`.
    - **`packages.nix`**: User CLI/GUI packages.
    - **`shell.nix`**: Shell configuration (Fish, Starship, tools).
    - **`git.nix`**: Git configuration.
    - **`turtle-wow.nix`**: Turtle WoW game client wrapper (AppImage + Wayland fixes).
- **`dotfiles/`**: Raw config files (symlinked).
  - `cosmic/`, `autostart/`.
- **`scripts/`**: Utility scripts (e.g., `concat_config.sh`).

## Custom Options API (`modules/nixos/core/options.nix`)

These options act as high-level feature flags.

| Option                            | Description                                                                      |
| :-------------------------------- | :------------------------------------------------------------------------------- |
| **`bigor.roles.desktop`**         | Enables full graphical environment (COSMIC), audio, fonts, and workstation apps. |
| **`bigor.roles.homelab_master`**  | Enables headless server services, container orchestration, and monitoring.       |
| **`bigor.sshd.enable`**           | Enables hardened OpenSSH server (no root login, key-based auth).                 |
| **`bigor.nfs.server`**            | Exports `/mnt/storage` via NFS.                                                  |
| **`bigor.nfs.client`**            | Mounts the shared NFS storage.                                                   |
| **`bigor.network.ips`**           | Defines static IPs for `grospc` and `minipc`.                                    |
| **`bigor.network.mainInterface`** | Defines the primary network interface (e.g., `enp2s0`).                          |

## Development Workflow

### 1. Apply Changes

Use `nh` (Nix Helper) for best results. It handles generation management and cleaning better than raw `nixos-rebuild`.

```bash
nh os switch              # Apply to current host
nh os switch -H minipc    # Apply to remote host
```

### 2. Dependency Management

```bash
nix flake update          # Update lockfile with new inputs
```

### 3. Code Quality

**ALWAYS** run before committing to ensure formatting and linting pass.

```bash
nix develop               # Enter dev shell
treefmt                   # Format code
nix build .#checks.x86_64-linux.git-hooks-check # Run linters
```
