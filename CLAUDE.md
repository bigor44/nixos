# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS Flake configuration repository using Flake-parts for organizing system and user configurations across multiple hosts. The configuration manages 3 hosts:

- **grospc**: Desktop workstation with COSMIC DE, gaming optimizations
- **minipc**: DNS/network server (homelab-master profile)
- **minidesk**: Portable workstation (workstation profile, no NFS mount)

Key technologies:

- **Flake-parts**: Modular flake organization framework
- **Home Manager**: User environment management (integrated via NixOS module)
- **Sops-Nix**: Secrets management with age encryption
- **NixVim**: Declarative Neovim configuration

## Common Commands

### System Management

```bash
# Rebuild and switch to new configuration using nh
nh os switch

# Build configuration without switching
nh os build

# Test configuration (reverts on reboot)
nh os test

# Build specific host
nh os switch --hostname minipc
```

### Development Workflow

```bash
# IMPORTANT: Always run these checks before 'nix flake check'
# 1. Format code with treefmt
nix fmt

# 2. Check for dead code
deadnix --fail .

# 3. Run statix linter
statix check --ignore .* .

# 4. Run all flake checks (formatting + linting)
nix flake check

# Update flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake outputs
nix flake show
```

### Fish Shell Abbreviations (defined in modules/home/shell/default.nix and modules/home/git/default.nix)

- `nfc` → `nix flake check`
- `nfu` → `nix flake update`
- `g` → `git`
- `gst` → `git status`
- `gc` → `git commit`
- `gaa` → `git add -A`
- `gp` → `git push`
- `ll` → `eza -l --icons --git`
- `la` → `eza -lah --icons --git`

### Secrets Management (Sops-Nix)

```bash
# Edit secrets (requires age key in ~/.config/sops/age/keys.txt)
sops secrets/secrets.yaml

# View encrypted secrets
sops -d secrets/secrets.yaml
```

### Linting and Formatting

```bash
# Check Nix formatting with treefmt
treefmt --check

# Auto-format all files
treefmt

# Run statix linter
statix check --ignore .* .

# Check for dead code
deadnix --fail .
```

## Architecture

### Flake-parts Structure

The repository uses Flake-parts with explicit module imports:

- **flake.nix**: Main entry point with flake-parts configuration
- **nix/modules.nix**: Explicit list of all NixOS and Home Manager modules
- **nix/hosts.nix**: NixOS configuration definitions for all hosts
- **modules/nixos/**: System-level NixOS modules (namespace: `bigor.features.*`, `bigor.profiles.*`, `bigor.services.*`, `bigor.network.*`)
- **modules/home/**: Home Manager modules (namespace: `bigor.home.*`)
- **hosts/**: Host-specific NixOS and Home Manager configurations
- **users/**: Base user configurations

### Directory Layout

```
/home/bigor/nixos/
├── flake.nix                    # Flake-parts entry point
├── nix/
│   ├── modules.nix              # Explicit module import list
│   └── hosts.nix                # NixOS configuration definitions
├── modules/
│   ├── nixos/                   # System modules
│   │   ├── features/            # Feature modules
│   │   ├── services/            # Service modules
│   │   └── profiles/            # Composite profiles
│   └── home/                    # Home Manager modules
├── hosts/
│   ├── grospc/
│   │   ├── default.nix          # NixOS config
│   │   ├── hardware-configuration.nix
│   │   └── home.nix             # Home Manager config
│   ├── minipc/
│   └── minidesk/
├── users/
│   └── bigor/
│       └── default.nix          # Base user config
├── secrets/
├── certs/
└── dotfiles/
```

### Module Organization

**System Modules** (`modules/nixos/`):

- **features/system/**: Core system features (base, boot, users, network, packages, sops, locale)
- **features/audio/**: PipeWire/ALSA audio stack
- **features/bluetooth/**: Bluetooth configuration
- **features/desktop/**: COSMIC DE, desktop apps, tuning
- **features/gaming/**: Steam, GameMode optimizations
- **features/fonts/**: Font configuration
- **profiles/**: Composite configurations
  - `workstation/`: Full desktop with COSMIC, audio, gaming
  - `homelab_master/`: DNS/network services
- **services/**: Network services (Blocky DNS, Caddy reverse proxy, NFS, SSH, Unbound)

**Home Modules** (`modules/home/`):

- **cli-packages/**: Modern CLI tools (eza, fd, ripgrep, btop, lazygit, etc.)
- **git/**: Git config and shell abbreviations
- **shell/**: Fish shell with Tide prompt, fzf, zoxide, bat
- **nixvim/**: Neovim with LSP, treesitter, completion, UI plugins
- **features/gui/**: Desktop applications (Prismlauncher, Discord, WhatsApp, Brave)

### Network Topology

Network configuration is centralized in `modules/nixos/features/system/network/default.nix`:

```nix
bigor.network.hosts = {
  minipc   = { ip = "192.168.1.10"; interface = "enp2s0"; };
  grospc   = { ip = "192.168.1.11"; interface = "enp14s0"; };
  minidesk = { ip = null; interface = "enp2s0"; };  # DHCP
};
```

This topology is used throughout the configuration:

- Generates `/etc/hosts` entries automatically
- Referenced by services (Blocky, Caddy, NFS)
- Provides consistent IP addressing via `config.bigor.network.hosts.<hostname>.ip`

### Module Pattern

All custom modules follow this pattern:

```nix
{ config, lib, ... }:
with lib;
let
  cfg = config.bigor.<category>.<module-name>;
in
{
  options.bigor.<category>.<module-name> = {
    enable = mkEnableOption "Description";
    # Additional options...
  };

  config = mkIf cfg.enable {
    # Module configuration...
  };
}
```

Enable modules in host configs:

```nix
bigor.features.audio.enable = true;
bigor.home.shell.enable = true;
```

### Secrets Architecture

Secrets are encrypted using Sops-Nix with age encryption:

- Age keys defined in `.sops.yaml` for user + all hosts
- Encrypted secrets stored in `secrets/secrets.yaml`
- Decrypted at runtime by sops-nix module
- Access in configuration: `config.sops.secrets.<secret-name>.path`

### Desktop Environment

The configuration uses COSMIC DE (System76's Rust-based desktop):

- Configuration files in `dotfiles/cosmic/` (symlinked, not copied)
- Can be edited live without rebuild
- COSMIC Greeter for display manager
- PipeWire for audio

### Service Stack

- **DNS**: Blocky (ad-blocking DNS proxy) → Unbound (recursive resolver)
- **HTTPS**: Caddy reverse proxy with automatic TLS
- **File Sharing**: NFS server/client
- **SSH**: OpenSSH server

## Making Changes

### Adding a New Module

1. Create module file in appropriate directory:
   - System module: `modules/nixos/features/<category>/<name>/default.nix`
   - Home module: `modules/home/<name>/default.nix`

2. Use the standard module pattern (see Architecture section)

3. Add the module path to `nix/modules.nix`:

   ```nix
   nixosModules = [
     # ... existing modules
     ../modules/nixos/features/<category>/<name>
   ];
   ```

4. Enable in host config:
   ```nix
   bigor.features.<category>.<name>.enable = true;
   ```

### Adding a New Host

1. Create host directory: `hosts/<hostname>/`
2. Create NixOS config: `hosts/<hostname>/default.nix`
3. Create Home Manager config: `hosts/<hostname>/home.nix` (imports `users/bigor`)
4. Generate hardware config: `nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix`
5. Add host to `nix/hosts.nix`:
   ```nix
   flake.nixosConfigurations = {
     # ... existing hosts
     <hostname> = mkHost "<hostname>";
   };
   ```
6. Add host to network topology in `modules/nixos/features/system/network/default.nix`

### Modifying COSMIC Configuration

COSMIC configs in `dotfiles/cosmic/` are symlinked:

- Edit files directly in `dotfiles/cosmic/`
- Changes apply immediately (no rebuild needed)
- Commit changes to track in git

### Working with Secrets

1. Ensure age key exists in `~/.config/sops/age/keys.txt`
2. Edit secrets: `sops secrets/secrets.yaml`
3. Reference in config:
   ```nix
   sops.secrets.my-secret = { };
   # Use: config.sops.secrets.my-secret.path
   ```

## Important Patterns

### Feature Toggle Pattern

Modules use enable options for composability:

```nix
bigor.features.audio.enable = true;
bigor.features.gaming.enable = true;
```

Profiles compose multiple features:

```nix
# profiles/workstation/default.nix enables:
# - desktop.base, desktop.cosmic, desktop.apps
# - audio, bluetooth, gaming, fonts
```

### Accessing Network Topology

Services can reference the network topology:

```nix
config.bigor.network.hosts.minipc.ip  # "192.168.1.10"
config.bigor.network.subnet           # "192.168.1.0/24"
```

### NixVim Configuration

Located in `modules/home/nixvim/`:

- `default.nix`: Main config and plugin imports
- `keymaps.nix`: Key bindings
- `opts.nix`: Vim options
- `autocmds.nix`: Auto-commands
- `plugins/`: Plugin configurations (ui, lsp, editor, treesitter, completion)

LSP servers configured: bashls, marksman, yaml-language-server, nixd

## Quality Assurance

Two automated checks run during `nix flake check` (defined in `flake.nix` perSystem):

1. **nix-fmt**: Verifies formatting with treefmt (nixfmt, shfmt, prettier, taplo)
2. **nix-lint**: Runs statix (linting) and deadnix (dead code detection)

Both checks must pass before committing.

## Notes

- This configuration uses `nixos-unstable` channel
- Namespace is `bigor` (enables `bigor.*` module options)
- Unfree packages are allowed globally
- Hardware configs are per-host in `hosts/<hostname>/hardware-configuration.nix`
- The formatter is `treefmt` (defined in perSystem)
