# Bigor's NixOS Flake Configuration

This repository contains the NixOS system configurations for Bigor's machines, managed as a **Nix Flake**. It unifies system-level configuration (NixOS) and user-level configuration (Home Manager).

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs and outputs (system configurations).
- **`hosts/`**: Host-specific configurations.
  - `grospc/`: Main desktop workstation.
    - **Channel**: `nixos-25.11` (Stable)
    - **Role**: Gaming, Development (`roles.desktop`).
    - **Features**: `sshd`, `nfs.client`.
  - `minipc/`: Secondary home server.
    - **Channel**: `nixos-25.11` (Stable)
    - **Role**: Infrastructure Services (`roles.homelab_master`).
    - **Features**: `sshd`, `nfs.server`, **Tailscale Optimization** (UDP GRO).
- **`modules/`**: Reusable modules.
  - `nixos/`: Custom NixOS modules.
    - **Roles**: `roles.desktop` (COSMIC DE, Audio, Fonts), `roles.homelab_master` (Headless Server).
    - **Services**: `adguard`, `caddy` (Reverse Proxy), `dashboard` (Homepage), `glances`, `nfs` (Server & Client), `tailscale` (VPN).
    - **Core**: System options, Locale, User management.
  - `home/`: Home Manager configuration for user `bigor`.
    - **CLI**: Git, Fish, Neovim, Eza, Fd, Ripgrep, Jq, Lazygit, Gemini-cli, Treefmt, Fzf, Zoxide, Bat.
    - **GUI**: Brave, Discord, OneDrive, YouTube Music, WhatsApp, Turtle WoW, Antigravity (FHS).
- **`dotfiles/`**: Configuration files managed via symlinks (COSMIC, Desktop entries).
- **`scripts/`**: Utility scripts.
- **`certs/`**: Custom certificates.

## Systems

Defined in `flake.nix`:

| Host         | Architecture   | Branch         | Description                            |
| :----------- | :------------- | :------------- | :------------------------------------- |
| **`grospc`** | `x86_64-linux` | Stable (25.11) | High-performance desktop (Zen Kernel). |
| **`minipc`** | `x86_64-linux` | Stable (25.11) | Stable home server for services.       |

## Key Commands

### Applying Configuration

Using `nh` (Nix Helper):

```bash
# Apply for the current machine
nh os switch

# Apply for a specific host
nh os switch --hostname minipc
```

### Managing Dependencies

Update all flake inputs (both stable and unstable):

```bash
nix flake update
```

### Development & Quality Assurance

This project ensures code quality using **Treefmt** (formatting) and **Pre-commit hooks** (linting).

**Enter the development shell:**

```bash
nix develop
```

**Tools included:**

- **Formatters** (managed by `treefmt`):
  - `nixpkgs-fmt` (Nix)
  - `prettier` (Markdown, JSON, YAML, etc.)
  - `stylua` (Lua)
  - `shfmt` (Shell)
  - `black` & `isort` (Python)
  - `taplo` (TOML)

- **Linters** (via `pre-commit-hooks`):
  - `statix` & `deadnix` (Nix)
  - `luacheck` (Lua)
  - `detect-secrets` (Secret scanning)

**Running Checks:**

```bash
# Run all formatters
treefmt

# Run pre-commit checks manually
nix build .#checks.x86_64-linux.pre-commit-check
```

## Custom Modules

- **Roles & Options**: High-level switches defined in `modules/nixos/core/options.nix`.
  - `roles.desktop`: Enables GUI (COSMIC), audio, fonts, and user apps.
  - `roles.homelab_master`: Enables headless server services and container orchestration.
  - `sshd.enable`: Enables SSH access with secure defaults.
  - `nfs.client` / `nfs.server`: Manages NFS file sharing.
- **NFS**:
  - **Server**: Enabled on `minipc` (`nfs.server = true`). Exports `/mnt/storage`.
  - **Client**: Enabled on `grospc` (`nfs.client = true`). Automounts storage.
- **Secrets**: `detect-secrets` baseline is used to prevent committing sensitive data.
