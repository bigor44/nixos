# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS Flake configuration repository using Flake-parts for organizing system and user configurations across multiple hosts. The configuration manages 3 hosts:

- **grospc**: Desktop workstation with COSMIC DE, gaming optimizations
- **minipc**: DNS/network server (homelab-master profile)
- **minidesk**: Portable workstation (same hardware as minipc, workstation profile, portable DNS mode)

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

### Zsh Shell Aliases (defined in modules/home/features/shell.nix and modules/home/features/git.nix)

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
- **nix/checks.nix**: Flake checks for formatting and linting
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
│   ├── hosts.nix                # NixOS configuration definitions
│   └── checks.nix               # Flake checks (formatting, linting)
├── modules/
│   ├── nixos/                   # System modules
│   │   ├── features/            # Feature modules
│   │   ├── services/            # Service modules
│   │   └── profiles/            # Composite profiles
│   └── home/                    # Home Manager modules
│       └── features/            # Feature modules
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

- **features/system/**: Core system features (`base.nix`, `boot.nix`, `users.nix`, `network.nix`, `packages.nix`, `sops.nix`, `french-locale.nix`)
- **features/audio.nix**: PipeWire/ALSA audio stack
- **features/bluetooth.nix**: Bluetooth configuration
- **features/desktop/**: COSMIC DE (`base.nix`, `cosmic.nix`, `apps.nix`)
- **features/gaming.nix**: Steam, GameMode optimizations
- **features/fonts.nix**: Font configuration
- **profiles/**: Composite configurations (`workstation.nix`, `homelab_master.nix`)
- **services/**: Network services (`blocky.nix`, `caddy.nix`, `nfs.nix`, `sshd.nix`, `unbound.nix`)

**Home Modules** (`modules/home/features/`):

- **cli-packages.nix**: Modern CLI tools (eza, fd, ripgrep, btop, lazygit, etc.)
- **git.nix**: Git config and shell aliases
- **shell.nix**: Zsh shell with Starship prompt, fzf, zoxide, bat
- **nixvim/**: Neovim with LSP, treesitter, completion, UI plugins (multi-file module)
- **gui.nix**: Desktop applications (Prismlauncher, Discord, WhatsApp, Brave)

### Policy Layer

The configuration uses a policy layer to separate strategic decisions (what) from implementation details (how). Policies are declared at the host level and consumed by feature/service modules.

**Available Policies:**

- `bigor.policies.kernel`: Kernel selection
  - `"server"`: LTS kernel for stability (linuxPackages)
  - `"desktop"`: Zen kernel for desktop performance (linuxPackages_zen)
  - `"hardened"`: Security-focused kernel (linuxPackages_hardened)
  - `"latest"`: Latest mainline kernel (linuxPackages_latest)

- `bigor.policies.power`: System-wide power management (kernel params, CPU governor, power-profiles-daemon)
  - `"amd-pstate"`: AMD P-State EPP active mode + power-profiles-daemon for runtime control
  - `"intel-pstate"`: Intel P-State active mode + power-profiles-daemon for runtime control
  - `"performance"`: Maximum performance with performance governor
  - `"balanced"`: Default kernel behavior, no explicit governor
  - `"powersave"`: Maximum power saving with powersave governor

  P-State modes enable power-profiles-daemon, allowing desktop environments (COSMIC, GNOME, KDE) to switch between performance/balanced/power-saver profiles at runtime.

- `bigor.policies.dns.mode`: DNS resolution strategy
  - `"local-recursive"`: Run Unbound + Blocky locally (server role)
  - `"lan-recursive"`: Use LAN recursive resolver (workstation pointing to minipc)
  - `"portable"`: Cloud DNS only, no LAN dependencies (portable hosts)
  - `"cloud"`: Direct cloud DNS (future: no filtering)

- `bigor.policies.storage.mode`: Storage access strategy
  - `"nfs-server"`: Export local storage via NFS (requires static IP + device)
  - `"nfs-client"`: Mount storage from minipc via NFS (requires static IP)
  - `"local"`: Local storage mount, no network sharing (requires device)
  - `"none"`: No storage mount

**Policy vs Profile vs Features:**

- **Policies** (`bigor.policies.*`): High-level strategic decisions (what kernel, what DNS strategy, what storage mode)
- **Profiles** (`bigor.profiles.*`): Feature composition bundles (workstation enables audio + desktop + gaming)
- **Features/Services** (`bigor.features.*`, `bigor.services.*`): Implementation details (how to configure PipeWire, Blocky, NFS)

**Example Host Configuration:**

```nix
bigor = {
  # Policies: strategic decisions visible at a glance
  policies = {
    kernel = "desktop";
    power = "amd-pstate";
    dns.mode = "lan-recursive";
    storage.mode = "nfs-client";
  };

  # Profile: feature composition
  profiles.workstation.enable = true;
};
```

**Benefits:**

- All strategic decisions visible in one block
- No duplication of kernel/power settings across hosts
- Service modules are pure implementation (no conditional logic for modes)
- Easy to change strategy globally (e.g., all desktops to latest kernel)
- Assertions validate policy coherence centrally

**Implementation Details:**

Policy modules provide computed read-only values that service modules consume:

- `bigor.policies.dns.computed.blockyUpstreams`: Computed DNS upstream list based on mode
- `bigor.policies.dns.computed.shouldRunUnbound`: Whether to run Unbound locally
- `bigor.policies.storage.computed.shouldRunNfsServer`: Whether to export via NFS
- `bigor.policies.storage.computed.shouldMountNfsClient`: Whether to mount remote NFS

This eliminates conditional logic scattered across service modules and centralizes all decision-making in the policy layer.

**Service Flexibility:**

While policies provide the recommended configuration path, services retain independent configurability for advanced use cases:

- **Blocky** (`bigor.services.blocky`):
  - `followDnsPolicy` (default: `true`): Use DNS policy for upstream configuration
  - Set to `false` to manually configure upstreams via `bigor.services.blocky.upstreams`
  - Useful for testing or custom DNS setups without changing the global policy

- **NFS** (`bigor.services.nfs`):
  - Direct `server`, `client`, and `localStorage` options are available but protected by assertions
  - Assertions ensure the storage policy has validated prerequisites (static IP, device availability)
  - Use the policy layer (`bigor.policies.storage.mode`) for safe, validated configuration

This design allows power users to override policy when needed while keeping the default path simple and safe.

### Network Topology

Network configuration is centralized in `modules/nixos/features/system/network.nix`:

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
let
  inherit (lib) mkEnableOption mkIf mkOption types;
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

**Key Points**:

- Use `inherit (lib)` to explicitly import needed functions from lib
- Avoid `with lib;` as it can cause naming conflicts and reduces code clarity
- Only inherit the functions you actually use in the module

Enable modules in host configs:

```nix
bigor.features.audio.enable = true;
bigor.home.features.shell.enable = true;
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
  - `useLocalUnbound`: Use local Unbound (minipc only)
  - `portableMode`: Skip minipc upstream, use Cloudflare directly (for portable hosts)
- **HTTPS**: Caddy reverse proxy with automatic TLS
- **File Sharing**: NFS (`modules/nixos/services/nfs.nix`)
  - `nfs.server`: Export `/mnt/storage` via NFS (requires local storage)
  - `nfs.client`: Mount `/mnt/storage` from minipc via NFS (requires static IP)
  - `nfs.localStorage`: Mount a local disk at `/mnt/storage`
  - Assertions ensure coherence (no client without static IP, no server without disk)
- **SSH**: OpenSSH server

### Kernel Selection

The configuration uses different Linux kernels optimized for each host's role:

- **minipc**: Linux LTS kernel (`linuxPackages`) for maximum stability and reliability. As a homelab server running critical network services (DNS, NFS, Caddy), stability and long-term support are prioritized over cutting-edge performance features.

- **minidesk** and **grospc**: Linux Zen kernel (`linuxPackages_zen`) for enhanced desktop performance and responsiveness. The Zen kernel includes patches optimized for desktop workloads, interactive applications, and gaming, providing better latency and throughput for workstation use cases.

This kernel strategy balances the needs of a stable server infrastructure with the performance demands of interactive desktop environments.

## Making Changes

### Adding a New Module

1. Create module file in appropriate directory:
   - System module: `modules/nixos/features/<category>/<name>.nix` or `modules/nixos/services/<name>.nix`
   - Home module: `modules/home/features/<name>.nix`

2. Use the standard module pattern (see Architecture section)

3. Add the module path to `nix/modules.nix`:

   ```nix
   nixosModules = [
     # ... existing modules
     ../modules/nixos/features/<category>/<name>.nix
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
6. Add host to network topology in `modules/nixos/features/system/network.nix`

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
# profiles/workstation.nix enables:
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

Located in `modules/home/features/nixvim/`:

- `default.nix`: Main config and plugin imports
- `keymaps.nix`: Key bindings
- `opts.nix`: Vim options
- `autocmds.nix`: Auto-commands
- `plugins/`: Plugin configurations (ui, lsp, editor, treesitter, completion)

LSP servers configured: bashls, marksman, yaml-language-server, nixd

## Quality Assurance

Two automated checks run during `nix flake check` (defined in `nix/checks.nix`):

1. **nix-fmt**: Verifies formatting with treefmt (nixfmt, shfmt, prettier, taplo)
2. **nix-lint**: Runs statix (linting) and deadnix (dead code detection)

Both checks must pass before committing.

## Notes

- This configuration uses `nixos-unstable` channel
- Namespace is `bigor` (enables `bigor.*` module options)
- Unfree packages are allowed globally
- Hardware configs are per-host in `hosts/<hostname>/hardware-configuration.nix`
- The formatter is `treefmt` (defined in perSystem)
