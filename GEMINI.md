# Bigor's NixOS Flake Configuration

This repository contains the NixOS system configurations for Bigor's machines, managed as a **Nix Flake**. It unifies system-level configuration (NixOS) and user-level configuration (Home Manager).

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs (nixpkgs, home-manager, etc.) and outputs (system configurations).
- **`hosts/`**: Host-specific configurations.
  - `grospc/`: Configuration for the main desktop (Zen kernel, gaming setup, backups). Role: `desktop`.
  - `minipc/`: Configuration for the secondary machine. Role: `server`.
- **`modules/`**: Reusable modules.
  - `nixos/`: Custom NixOS modules.
    - **Roles**: `desktop` (GUI, Audio, NFS Client), `server` (Headless, Infrastructure Services), `hybrid` (Desktop + SSH).
    - **Services**: `adguard`, `caddy` (Reverse Proxy), `dashboard` (Homepage), `nfs` (File Sharing), `sshd`, `tailscale` (VPN), `vaultwarden` (Passwords).
    - **Desktop**: Configuration for Audio, Bluetooth, Fonts, Desktop Environment (COSMIC).
    - **Core**: Options, Locale, System Packages, Users.
  - `home/`: Home Manager configuration for the user `bigor`.
    - **CLI**: Git, Shell (Fish, Tmux), Nixvim, Fastfetch, Btop.
    - **GUI Apps**: Brave, Discord, OneDrive, YouTube Music, WhatsApp, Turtle WoW (Custom Wrapper), Antigravity.
- **`dotfiles/`**: Raw configuration files (e.g., desktop entries, COSMIC settings) meant to be linked or included.
- **`scripts/`**: Utility scripts (e.g., `concat_config.sh` for aggregating config files).
- **`certs/`**: Custom certificates (e.g., `minipc-ca.pem`).

## Systems

Defined in `flake.nix`:

- **`grospc`**: `x86_64-linux`. Role: **Desktop**. Main workstation with gaming optimizations.
- **`minipc`**: `x86_64-linux`. Role: **Server**. Runs infrastructure services (AdGuard, Vaultwarden, Dashboard, Caddy, NFS Server).

## Key Commands

### Applying Configuration

This configuration uses `nh` (Nix Helper) for faster and prettier deployments.

To apply the configuration for the current machine:

```bash
nh os switch
```

To apply for a specific host (e.g., `grospc`):

```bash
nh os switch --hostname grospc
```

### Managing Dependencies

Update all flake inputs:

```bash
nix flake update
```

### Cleaning Up

Garbage collect old generations:

```bash
nh clean all
```

### Development & Quality Assurance

This project uses `pre-commit-hooks` via `flake-parts` to ensure code quality.

**Enter the development shell:**

```bash
nix develop
```

**Run checks (linters & formatters):**

```bash
nix build .#checks.x86_64-linux.pre-commit-check
```

Or simply commit your changes, as the hooks are installed by `nix develop`.

**Tools included:**

- **Formatters:** `nixfmt-rfc-style` (Nix), `prettier` (general), `shfmt` (Shell).
- **Linters:** `statix`, `deadnix` (Nix), `detect-secrets`.
- **CLI Tools:** `nh`, `gemini-cli`.

## Custom Modules

- **Roles:** The configuration uses a custom `system.role` option to conditionally enable groups of modules.
  - `desktop`: Enables graphical environment (COSMIC), audio, fonts, and NFS client.
  - `server`: Enables headless operation and all infrastructure services (AdGuard, Dashboard, Vaultwarden, Tailscale, NFS Server, Caddy).
  - `hybrid`: Combines `desktop` features with `sshd` access.
- **Secrets:** `detect-secrets` is configured to prevent committing sensitive data.
