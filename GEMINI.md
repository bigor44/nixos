# Bigor's NixOS Flake Configuration

This repository contains the NixOS system configurations for Bigor's machines, managed as a **Nix Flake**. It unifies system-level configuration (NixOS) and user-level configuration (Home Manager).

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs (nixpkgs, home-manager, nixvim, etc.) and outputs (system configurations).
- **`hosts/`**: Host-specific configurations.
  - `grospc/`: Configuration for the main desktop (Zen kernel, gaming setup, backups). Role: `desktop`.
  - `minipc/`: Configuration for the secondary machine. Role: `server`.
- **`modules/`**: Reusable modules.
  - `nixos/`: Custom NixOS modules.
    - **Roles**: `desktop` (GUI, Audio), `server` (Headless), `hybrid` (Desktop + SSH).
    - **Services**: `adguard`, `caddy` (Reverse Proxy), `dashboard` (Homepage), `nfs` (File Sharing), `sshd`, `tailscale` (VPN), `vaultwarden` (Passwords).
    - **Desktop**: Configuration for Audio, Bluetooth, Fonts, Desktop Environment.
  - `home/`: Home Manager configuration for the user `bigor`.
    - **Apps**: Git, Shell, NixVim.
    - **Turtle WoW**: Custom wrapper (`turtle-wow.nix`) for Wayland compatibility + Desktop Entry.
- **`dotfiles/`**: Raw configuration files (e.g., desktop entries, COSMIC settings) meant to be linked or included.
- **`scripts/`**: Utility scripts (e.g., `concat_config.sh` for aggregating config files).
- **`certs/`**: Custom certificates (e.g., `minipc-ca.pem`).

## Systems

Defined in `flake.nix`:

- **`grospc`**: `x86_64-linux`. Role: **Desktop**. Main workstation with gaming optimizations.
- **`minipc`**: `x86_64-linux`. Role: **Server**. Runs infrastructure services (AdGuard, Vaultwarden, Dashboard).

## Key Commands

### Applying Configuration

To apply the configuration for the current machine:

```bash
sudo nixos-rebuild switch --flake .
```

To apply for a specific host (e.g., `grospc`):

```bash
sudo nixos-rebuild switch --flake .#grospc
```

### Managing Dependencies

Update all flake inputs:

```bash
nix flake update
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

## Custom Modules

- **Roles:** The configuration uses a custom `system.role` option to conditionally enable groups of modules.
  - `desktop`: Enables graphical environment (COSMIC/Gnome), audio, fonts.
  - `server`: Minimal setup for headless operation.
  - `hybrid`: Combines `desktop` features with `sshd` access.
- **Secrets:** `detect-secrets` is configured to prevent committing sensitive data.
