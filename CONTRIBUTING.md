# Contributing to Bigor's NixOS Configuration

Thank you for your interest in contributing! This document outlines the development workflow and standards for this repository.

## Development Environment

### Prerequisites

- NixOS with flakes enabled
- Git configured with your name and email
- [nh](https://github.com/viperML/nh) - Nix Helper (recommended for rebuilds)
- Age key in `~/.config/sops/age/keys.txt` (for secrets management)

### Shell Abbreviations

The Fish shell configuration includes helpful abbreviations:

```bash
nfc     # nix flake check
nfu     # nix flake update
g       # git
gst     # git status
gc      # git commit
gaa     # git add -A
gp      # git push
ll      # eza -l --icons --git
```

## Development Workflow

### 1. Making Changes

#### Before You Start

1. Create a new branch for your changes:

   ```bash
   git checkout -b feature/my-feature
   ```

2. Make your changes following the module pattern (see below)

#### Module Pattern

All modules follow this structure:

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

**Key Points**:

- Use the `bigor` namespace for all custom options
- System modules: `bigor.nixos.*`
- Home modules: `bigor.home.*`
- Always provide an `enable` option
- Use descriptive option names

### 2. Code Quality

#### Formatting and Linting (CRITICAL)

**You MUST run these checks in order before committing:**

```bash
# 1. Format code with treefmt
nix fmt

# 2. Check for dead code
deadnix --fail .

# 3. Run statix linter
statix check --ignore .* .

# 4. Run all flake checks
nix flake check
```

**Why this order matters**:

- `nix fmt` fixes formatting issues automatically
- `deadnix` detects unused code that should be removed
- `statix` catches common Nix anti-patterns
- `nix flake check` runs both formatting and linting checks again, ensuring everything passes

#### What Each Tool Does

- **treefmt** (`nix fmt`): Multi-language formatter
  - Nix files: `nixfmt` (RFC 166 style)
  - Shell scripts: `shfmt`
  - Markdown/JSON/YAML: `prettier`
  - TOML files: `taplo`

- **deadnix**: Detects dead (unused) code in Nix files
  - Removes clutter and improves maintainability
  - `--fail` flag ensures CI catches dead code

- **statix**: Lints Nix code for common issues
  - Catches anti-patterns and potential bugs
  - `--ignore .*` skips hidden directories (like `.git`)

### 3. Testing Changes

#### Local Testing

```bash
# Build without switching (safe way to test)
nh os build

# Test configuration (reverts on reboot)
nh os test

# Apply changes permanently
nh os switch
```

#### Test Specific Hosts

```bash
# Build configuration for a specific host
nh os build --hostname minipc

# Switch specific host
nh os switch --hostname minipc
```

### 4. Committing Changes

#### Commit Message Format

Use clear, descriptive commit messages:

```
<type>: <subject>

<body (optional)>
```

**Types**:

- `feat`: New feature or module
- `fix`: Bug fix
- `refactor`: Code restructuring without behavior change
- `docs`: Documentation changes
- `chore`: Maintenance tasks (updates, cleanup)
- `style`: Formatting, whitespace (should be rare with auto-formatting)

**Examples**:

```
feat: add bluetooth module for desktop systems

fix: resolve COSMIC autostart configuration issue

refactor: simplify network topology module

docs: update CLAUDE.md with nh commands

chore: update flake inputs to latest versions
```

#### Commit Workflow

```bash
# Stage your changes
git add -A

# Commit with a descriptive message
git commit -m "feat: add bluetooth module"

# Push to your branch
git push origin feature/my-feature
```

### 5. Pull Requests

1. **Ensure all checks pass** before creating a PR:

   ```bash
   nix fmt && deadnix --fail . && statix check --ignore .* . && nix flake check
   ```

2. **Test on a real system** - build and test your changes:

   ```bash
   nh os test
   ```

3. **Create a PR** with:
   - Clear description of changes
   - Why the changes are needed
   - Any breaking changes or migration steps
   - Which hosts are affected

4. **PR Title Format**: Same as commit messages
   ```
   feat: add bluetooth support to workstation profile
   ```

## Adding New Components

### Adding a New Module

1. **Create the module file**:

   ```bash
   # System module
   mkdir -p modules/nixos/features/<category>/<name>
   touch modules/nixos/features/<category>/<name>/default.nix

   # Home module
   mkdir -p modules/home/<name>
   touch modules/home/<name>/default.nix
   ```

2. **Implement using the module pattern** (see above)

3. **Snowfall Lib auto-discovers modules** - no manual imports needed!

4. **Enable in a host configuration**:

   ```nix
   bigor.nixos.features.<category>.<name>.enable = true;
   ```

5. **Test and commit**:
   ```bash
   nix fmt
   deadnix --fail .
   statix check --ignore .* .
   nix flake check
   nh os test
   ```

### Adding a New Host

1. **Create system configuration**:

   ```bash
   mkdir -p systems/x86_64-linux/<hostname>
   ```

2. **Create `systems/x86_64-linux/<hostname>/default.nix`**:

   ```nix
   { lib, ... }:
   {
     networking.hostName = "<hostname>";

     bigor.nixos.profiles.<profile>.enable = true;
     # or enable individual features:
     # bigor.nixos.features.audio.enable = true;

     # Host-specific configuration...
   }
   ```

3. **Create home configuration**:

   ```bash
   mkdir -p homes/x86_64-linux/bigor@<hostname>
   ```

4. **Create `homes/x86_64-linux/bigor@<hostname>/default.nix`**:

   ```nix
   { ... }:
   {
     bigor.home.shell.enable = true;
     # Additional home configuration...
   }
   ```

5. **Add to network topology** in `modules/nixos/features/system/network/default.nix`:

   ```nix
   bigor.network.hosts.<hostname> = {
     ip = "192.168.1.XX";  # or null for DHCP
     interface = "enp0s0";
   };
   ```

6. **Generate hardware configuration**:

   ```bash
   nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
   bash scripts/post_install.sh <hostname>
   ```

7. **Test the new host**:
   ```bash
   nh os build --hostname <hostname>
   ```

### Adding a New Service

1. **Create service module** in `modules/nixos/services/<name>/default.nix`

2. **Follow the module pattern** with service-specific options

3. **Reference network topology** when needed:

   ```nix
   config.bigor.network.hosts.minipc.ip
   config.bigor.network.subnet
   ```

4. **Test service functionality** after deployment

## Working with Secrets

### Adding a New Secret

1. **Ensure you have the age key**:

   ```bash
   ls ~/.config/sops/age/keys.txt
   ```

2. **Edit secrets file**:

   ```bash
   sops secrets/secrets.yaml
   ```

3. **Add your secret** in the YAML file:

   ```yaml
   my_secret_key: "secret_value"
   ```

4. **Reference in configuration**:

   ```nix
   sops.secrets.my_secret_key = { };

   # Use the secret
   services.myservice.passwordFile = config.sops.secrets.my_secret_key.path;
   ```

### Secret Naming Convention

- Use lowercase with underscores: `my_secret_key`
- Group related secrets with prefixes: `caddy_admin_password`, `caddy_api_token`
- Never commit unencrypted secrets!

## Modifying COSMIC Configuration

COSMIC DE configuration files in `dotfiles/cosmic/` are **symlinked** (not copied):

1. **Edit files directly** in `dotfiles/cosmic/`
2. **Changes apply immediately** - no rebuild needed
3. **Commit changes** to track in git:
   ```bash
   git add dotfiles/cosmic/
   git commit -m "chore: update COSMIC panel configuration"
   ```

## Code Style Guidelines

### Nix Code

- **Use RFC 166 style** (enforced by nixfmt)
- **Prefer explicit over implicit**
- **Use meaningful variable names**
- **Add comments** for complex logic
- **Avoid dead code** (detected by deadnix)

### File Organization

- **One module per directory** with `default.nix`
- **Group related modules** under feature categories
- **Keep host configs minimal** - use modules for reusability
- **Separate concerns** - system vs. home modules

### Module Options

- **Always provide descriptions** for options
- **Use appropriate types** (`types.bool`, `types.str`, etc.)
- **Provide sensible defaults** when appropriate
- **Document breaking changes** in commit messages

## Quality Standards

All contributions must:

1. ✅ Pass `nix fmt` (automatic formatting)
2. ✅ Pass `deadnix --fail .` (no dead code)
3. ✅ Pass `statix check --ignore .* .` (no lint errors)
4. ✅ Pass `nix flake check` (all automated checks)
5. ✅ Build successfully (`nh os build`)
6. ✅ Follow the module pattern
7. ✅ Include clear commit messages

## Getting Help

- **Check CLAUDE.md** for architecture details
- **Read existing modules** for examples
- **Test changes locally** before committing
- **Ask questions** in issues or discussions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
