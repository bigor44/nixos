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

## Quality Assurance Workflow

The repository uses a **3-tier QA system** optimized for speed during development while maintaining CI-grade validation for commits and pushes.

### Quick Reference

```bash
# During active development (instant feedback, <0.1s)
qc              # Quick check: changed files only
nix fmt         # Auto-format all files

# Before committing
qs              # Quick check: staged files
gcn             # Safe commit: format + add all + check + commit

# Before pushing
gps             # Safe push: full check + push
qf              # Full check without push

# Intelligent orchestration
mega            # Auto-detect git state and run appropriate checks
```

### Check Tiers

**Tier 1 - Instant (< 0.1s)** - Changed files only:

```bash
qc                    # Quick check on modified files
check-quick           # Same, explicit command
qs                    # Quick check on staged files (for pre-commit)
check-quick --staged  # Same, explicit command
```

**Tier 2 - Full (~16.5s)** - Complete validation:

```bash
qf              # Full check: format + lint + dead code + eval + flake checks
check-full      # Same, explicit command
nix flake check # Raw Nix flake checks (still works)
```

**Tier 3 - Intelligent** - Adaptive based on git state:

```bash
mega            # Analyzes git state and chooses appropriate check
check-mega      # Same, explicit command
```

### Performance Comparison

| Workflow       | Before (manual) | After (new system) | Speedup |
| -------------- | --------------- | ------------------ | ------- |
| Dev cycle      | 16.5s           | 0.03s              | 500x    |
| Pre-commit     | Manual/skipped  | Automatic, <0.1s   | ∞       |
| Pre-push       | Not validated   | 16.5s (automatic)  | N/A     |
| CI equivalence | 16.5s           | 16.5s (same)       | 1x      |

### Pre-Commit Hooks

**Installation** (one-time per clone):

```bash
# Automatic via devShell (recommended)
nix develop

# Manual installation
install-git-hooks
```

**What it validates:**

- Format check on staged `.nix` files (nixfmt)
- Linter check (statix + deadnix)
- SOPS secrets validation (if modified)
- Prevention of sensitive file commits (`.pem`, `.key`, etc.)

**Skip when needed:**

```bash
git commit --no-verify
```

### Safe Workflow Aliases

**gcn** - Safe commit (format + add all + check + commit):

```bash
gcn -m "feat: add new feature"
# Equivalent to: nix fmt && gaa && qs && gc -m "..."
```

**gps** - Safe push (full check before push):

```bash
gps
# Equivalent to: check-full && gp
```

**nhs** - Safe rebuild (full check before switch):

```bash
nhs
# Equivalent to: check-full && nh os switch
```

### Development Workflow

**Recommended workflow:**

1. **Develop**: Edit code, run `qc` after changes (instant feedback)
2. **Format**: Run `nix fmt` before staging
3. **Commit**: Use `gcn -m "message"` (validates automatically)
4. **Push**: Use `gps` (full check + push)

**Alternative workflow (more control):**

1. Edit code
2. `qc` - Quick check
3. `nix fmt` - Format
4. `git add -A` - Stage changes
5. `qs` - Check staged files
6. `git commit -m "message"` - Pre-commit hook validates
7. `qf` - Full check
8. `git push` - Push to remote

### Manual Checks

```bash
# Format
nix fmt                           # Auto-format all files
treefmt --check                   # Check only (no changes)

# Linting
statix check --ignore .* .        # Run statix linter
deadnix --fail .                  # Check for dead code

# Full validation pipeline
check-full                        # Orchestrated full check (5 steps)
nix flake check                   # Raw flake checks

# Update dependencies
nix flake update                  # Update all inputs (alias: nfu)
nix flake lock --update-input nixpkgs  # Update specific input
nix flake show                    # Show flake outputs
```

### Assertion Validation

The repository includes **automatic policy assertion checks** that validate strategic decisions during `nix flake check`.

**What's validated:**

- DNS mode prerequisites (static IP requirements for `local-recursive`, minipc availability for `lan-recursive`)
- Storage mode prerequisites (static IP for NFS modes, device availability for local/server modes)
- Policy coherence (no conflicting configurations like NFS client with local device)

**How it works:**

```bash
# Assertions are validated during any full check
check-full                        # Includes assertion validation
nix flake check                   # Also validates assertions

# Per-host assertion checks are available
nix build .#checks.x86_64-linux.grospc-assertions --no-link
nix build .#checks.x86_64-linux.minipc-assertions --no-link
nix build .#checks.x86_64-linux.minidesk-assertions --no-link
```

**Benefits:**

- **Fail fast**: Catch configuration errors at validation time, not at rebuild time
- **Lightweight**: Assertions are evaluated without building the full system (~3-4s for all hosts)
- **CI-safe**: All `nix flake check` runs validate assertions automatically
- **Clear messages**: Failed assertions show exactly what's wrong and which host is affected

**Example failure:**

```bash
$ nix build .#checks.x86_64-linux.minidesk-assertions --no-link
error: Failed assertions for minidesk:
- Storage policy 'nfs-client' requires a static IP for minidesk
- Storage policy 'nfs-client' should not have local device (conflicts with remote mount)
```

This ensures that the policy layer's strategic assertions are **always validated** before code is committed or pushed, preventing invalid configurations from entering the repository.

### CI Workflow

For CI/PR checks, use the full check:

```bash
check-full
```

This runs:

1. Format validation (treefmt)
2. Dead code check (deadnix)
3. Linter check (statix)
4. Evaluation check (nix flake show)
5. Full flake checks (nix flake check)

### Statix Configuration

The repository includes `.statix.toml` documenting code conventions:

- **No `with lib;`** - Use explicit imports: `inherit (lib) mkOption mkIf;`
- **Use mkEnableOption** - For all feature modules
- **Policy modules** - Use `readOnly` options for computed values
- **Disabled rules** - Only `eta_reduction` (can reduce readability)

### Shell Aliases Reference

**Quality Assurance:**

- `qc` → `check-quick` (changed files)
- `qs` → `check-quick --staged` (staged files)
- `qf` → `check-full` (complete validation)
- `mega` → `check-mega` (intelligent check)

**Safe Workflows:**

- `gcn` → Format + add all + check + commit
- `gps` → Full check + push
- `nhs` → Full check + rebuild

**Nix:**

- `nfc` → `nix flake check`
- `nfu` → `nix flake update`

**Git:**

- `g` → `git`
- `gst` → `git status`
- `gc` → `git commit`
- `gaa` → `git add -A`
- `gp` → `git push`

**Navigation:**

- `ll` → `eza -l --icons --git`
- `la` → `eza -lah --icons --git`

### Secrets Management (Sops-Nix)

```bash
# Edit secrets (requires age key in ~/.config/sops/age/keys.txt)
sops secrets/secrets.yaml

# View encrypted secrets
sops -d secrets/secrets.yaml
```

Pre-commit hook automatically validates SOPS secrets when modified.

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
- **profiles/**: Composite configurations (`workstation.nix`, `homelab-master.nix`)
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
- `bigor.policies.dns.fallbackUpstreams`: Fallback cloud DNS servers (default: `["1.1.1.1" "9.9.9.9"]`)
  - Used as failover in `lan-recursive` mode when minipc is unreachable
  - Used as primary upstreams in `portable` and `cloud` modes

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
- **Assertions centralized in policy layer**: Strategic validations (static IP requirements, device availability) are authoritative in policy modules; service modules only contain technical assertions

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
  - Fallback upstreams are centrally configured via `bigor.policies.dns.fallbackUpstreams`
  - Useful for testing or custom DNS setups without changing the global policy

- **NFS** (`bigor.services.nfs`):
  - Direct `server`, `client`, and `localStorage` options are available for manual configuration
  - **Strategic assertions** (static IP requirements, device availability) are validated by `bigor.policies.storage`
  - **Technical assertions** (localStorage requires device, cannot be server+client) remain in the service module
  - Recommended: Use the policy layer (`bigor.policies.storage.mode`) for safe, validated configuration

**Assertion Architecture:**

- **Policy Layer** (`modules/nixos/policies/`): Authoritative source for strategic assertions
  - Validates prerequisites: static IP requirements, device availability, mode coherence
  - Example: "nfs-server requires static IP", "local-recursive DNS requires static IP"
  - **Automatically validated** during `nix flake check` (see Quality Assurance → Assertion Validation)

- **Service Layer** (`modules/nixos/services/`, `modules/nixos/features/`): Technical assertions only
  - Validates implementation constraints: "cannot be NFS server and client", "localStorage requires device"
  - No duplication of strategic validations

This design allows power users to override policy when needed while keeping the default path simple and safe. All policy assertions are **validated automatically** during QA checks, ensuring invalid configurations are caught before commit/push (not at rebuild time).

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

**Note on nixd configuration**: The flake path is hardcoded to `/home/bigor/nixos` instead of using `inputs.self.outPath` for stability. Using `inputs.self.outPath` can cause nixd issues when the git tree is dirty, as the path may change unexpectedly.

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
