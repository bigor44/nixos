# Bigor's NixOS Flake Configuration

This repository contains the NixOS system configurations for Bigor's machines, managed as a **Nix Flake**. It unifies system-level configuration (NixOS) and user-level configuration (Home Manager).

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs and outputs (system configurations).
- **`hosts/`**: Host-specific configurations.
  - `grospc/`: Main desktop workstation.
    - **Channel**: `nixos-unstable`
    - **Role**: Gaming, Development.
    - **Features**: `desktop`, `sshd`, `nfs-client`.
  - `minipc/`: Secondary home server.
    - **Channel**: `nixos-25.11` (Stable)
    - **Role**: Infrastructure Services.
    - **Features**: `server`, `sshd`.
- **`modules/`**: Reusable modules.
  - `nixos/`: Custom NixOS modules.
    **Features**: `desktop` (COSMIC DE, Audio, Fonts), `server` (Headless), `sshd`, `nfs-client`.
    - **Services**: `adguard`, `caddy` (Reverse Proxy), `dashboard` (Homepage), `glances`, `nfs` (Server & Client), `tailscale` (VPN), `vaultwarden`.
    - **Core**: System options, Locale, User management.
  - `home/`: Home Manager configuration for user `bigor`.
    - **CLI**: Git, Fish, Neovim, Eza, Fd, Ripgrep, Jq, Lazygit, Gemini-cli, Treefmt.
    - **GUI**: Brave, Discord, OneDrive, YouTube Music, WhatsApp, Turtle WoW, Antigravity.
- **`dotfiles/`**: Configuration files managed via symlinks (COSMIC, Desktop entries).
- **`scripts/`**: Utility scripts.
- **`certs/`**: Custom certificates.

## Systems

Defined in `flake.nix`:

| Host         | Architecture   | Branch         | Description                            |
| :----------- | :------------- | :------------- | :------------------------------------- |
| **`grospc`** | `x86_64-linux` | Unstable       | High-performance desktop (Zen Kernel). |
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
  - `nixfmt` (Nix)
  - `prettier` (Markdown, JSON, YAML, etc.)
  - `stylua` (Lua)
  - `shfmt` (Shell)
  - `black` & `isort` (Python)
  - `taplo` (TOML)
  - `yamlfmt` (YAML)
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

- **Features**: High-level switches in `system.features` (boolean options).
  - `desktop`: Enables GUI, audio, fonts, and desktop apps.
  - `server`: Enables headless mode and server services.
- **NFS**:
  - **Server**: Enabled on `minipc`. Exports `/mnt/storage`.
  - **Client**: Enabled on `grospc`. Automounts storage.
- **Secrets**: `detect-secrets` baseline is used to prevent committing sensitive data.
