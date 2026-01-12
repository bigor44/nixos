# Contributing to Bigor's NixOS Configuration

Thank you for your interest in contributing! This document outlines the development workflow and standards for this repository.

## Development Environment

### Prerequisites

- NixOS with flakes enabled
- Git configured with your name and email
- [nh](https://github.com/viperML/nh) - Nix Helper (recommended for rebuilds)
- Age key in `~/.config/sops/age/keys.txt` (for secrets management)

### Shell Aliases

The Zsh shell configuration includes helpful aliases:

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
let
  inherit (lib) mkIf mkEnableOption mkOption types;
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
- System modules:
  - Common (non-optional): `modules/nixos/common/` - NO `enable` option, applied to all hosts
  - Features (optional): `bigor.features.*` - WITH `enable` option
  - Services: `bigor.services.*` - WITH `enable` option
  - Profiles: `bigor.profiles.*` - WITH `enable` option
  - Policies: `bigor.policies.*` - NO `enable` option, use enum selection
- Home modules: `bigor.home.*`
- Always provide an `enable` option for features/services/profiles (but NOT for policies or common modules)
- Use descriptive option names
- **Avoid `with lib;`** - prefer explicit `inherit (lib)` for better readability and to avoid naming conflicts

#### Policy Module Pattern

Policies are a special type of module that declare **strategic architectural decisions** with complex downstream effects (DNS strategy, storage patterns). Unlike features/services, **policies do not have an `enable` option** - they are always active and use enums to select strategies.

**IMPORTANT**: Only create policies for decisions that:

- Represent fundamentally different architectural patterns
- Have cascading effects on multiple services
- Require computed values used by other modules
- Are used differently across multiple hosts

For simple configuration choices, use direct NixOS options or auto-detecting features instead.

**Example policy module:**

```nix
{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.bigor.policies.<policy-name>;
in
{
  options.bigor.policies.<policy-name> = mkOption {
    type = types.enum [ "option1" "option2" "option3" ];
    default = "option1";
    description = ''
      Policy description explaining each option:
      - "option1": Description of strategy 1
      - "option2": Description of strategy 2
      - "option3": Description of strategy 3
    '';
  };

  config = {
    # Implement the policy by setting low-level NixOS options
    # based on the selected strategy
  };
}
```

**Policy modules may also provide computed values** for other modules to consume:

```nix
options.bigor.policies.<policy-name>.computed = {
  someValue = mkOption {
    type = types.bool;
    readOnly = true;
    default = cfg == "option2";
  };
};
```

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

**For optional features or services:**

1. **Create the module file**:

   ```bash
   # Optional feature module
   touch modules/nixos/features/<name>.nix
   # or in a subdirectory: modules/nixos/features/<category>/<name>.nix

   # Service module
   touch modules/nixos/services/<name>.nix

   # Home module
   touch modules/home/<name>.nix
   ```

2. **Implement using the module pattern** with `enable` option (see above)

3. **Add the module to `nix/modules.nix`**:

   ```nix
   nixosModules = [
     # ... existing modules
     ../modules/nixos/features/<name>.nix  # or services/
   ];

   # or for home modules:
   homeModules = [
     # ... existing modules
     ../modules/home/<name>.nix
   ];
   ```

4. **Enable in a host configuration**:

   ```nix
   bigor.features.<name>.enable = true;
   # or bigor.services.<name>.enable = true;
   ```

5. **Test and commit**:
   ```bash
   nix fmt
   deadnix --fail .
   statix check --ignore .* .
   nix flake check
   nh os test
   ```

**For non-optional base configuration:**

1. **Create the module file**:

   ```bash
   touch modules/nixos/common/<name>.nix
   ```

2. **Implement WITHOUT `enable` option** (always applied to all hosts)

3. **Add to `nix/modules.nix`** under common section:

   ```nix
   nixosModules = [
     # Common - Non-optional base configuration
     ../modules/nixos/common/<name>.nix
     # ...
   ];
   ```

4. **Configuration is applied automatically** to all hosts

5. **Alternative**: For truly universal infrastructure config (like Nix caches), add directly to `nix/hosts.nix` in the `mkHost` function

### Adding a New Host

1. **Create host directory**:

   ```bash
   mkdir -p hosts/<hostname>
   ```

2. **Create `hosts/<hostname>/default.nix`** (NixOS config):

   ```nix
   { pkgs, ... }:
   {
     imports = [ ./hardware-configuration.nix ];

     networking.hostName = "<hostname>";
     system.stateVersion = "25.11";

     bigor.profiles.<profile>.enable = true;
     # or enable individual features:
     # bigor.features.audio.enable = true;

     # Host-specific configuration...
   }
   ```

3. **Create `hosts/<hostname>/home.nix`** (Home Manager config):

   ```nix
   { ... }:
   {
     imports = [ ../../users/bigor ];

     home.stateVersion = "25.11";

     # Host-specific home configuration...
     # bigor.home.features.gui.enable = true;
   }
   ```

4. **Generate hardware configuration**:

   ```bash
   nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
   ```

5. **Add to `nix/hosts.nix`**:

   ```nix
   flake.nixosConfigurations = {
     # ... existing hosts
     <hostname> = mkHost "<hostname>";
   };
   ```

6. **Add to network topology** in `nix/network-topology.nix`:

   ```nix
   hosts.<hostname> = {
     ip = "192.168.1.XX";  # or null for DHCP
     interface = "enp0s0";
   };
   ```

7. **Test the new host**:
   ```bash
   nh os build --hostname <hostname>
   ```

### Adding a New Service

1. **Create service module** in `modules/nixos/services/<name>.nix`

2. **Follow the module pattern** with service-specific options

3. **Add to `nix/modules.nix`**:

   ```nix
   nixosModules = [
     # ... existing modules
     ../modules/nixos/services/<name>.nix
   ];
   ```

4. **Reference network topology** when needed:

   ```nix
   config.bigor.network.hosts.minipc.ip
   config.bigor.network.subnet
   ```

5. **Test service functionality** after deployment

### Adding a New Policy

Policies centralize strategic decisions (kernel selection, DNS strategy, storage mode, etc.) to avoid duplication across hosts.

1. **Create policy module** in `modules/nixos/policies/<policy-name>.nix`:

   ```nix
   { config, lib, ... }:
   let
     inherit (lib) mkOption types;
     cfg = config.bigor.policies.<policy-name>;
   in
   {
     options.bigor.policies.<policy-name> = mkOption {
       type = types.enum [ "strategy1" "strategy2" "strategy3" ];
       default = "strategy1";
       description = ''
         Policy description:
         - "strategy1": Description
         - "strategy2": Description
         - "strategy3": Description
       '';
     };

     config = {
       # Implement policy by setting NixOS options based on strategy
       # Example: boot.kernelPackages = { strategy1 = ...; strategy2 = ...; }.${cfg};
     };
   }
   ```

2. **Add to `nix/modules.nix`**:

   ```nix
   nixosModules = [
     # ... existing modules
     # Policies (strategic decisions)
     ../modules/nixos/policies/<policy-name>.nix
   ];
   ```

3. **Add computed values** if other modules need to consume policy decisions:

   ```nix
   options.bigor.policies.<policy-name>.computed = {
     shouldDoSomething = mkOption {
       type = types.bool;
       readOnly = true;
       default = cfg == "strategy2";
       description = "Computed flag for service modules to read";
     };
   };
   ```

4. **Add assertions** to validate policy coherence:

   ```nix
   config.assertions = [
     {
       assertion = cfg == "strategy2" -> <some-condition>;
       message = "Policy 'strategy2' requires <condition>";
     }
   ];
   ```

5. **Use in host configuration**:

   ```nix
   bigor.policies.<policy-name> = "strategy2";
   ```

6. **Test all affected hosts**:
   ```bash
   nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
   ```

**Benefits of policies:**

- Centralize strategic decisions in one place
- Eliminate duplication (e.g., kernel selection across multiple hosts)
- Service modules become pure implementation (no conditional logic)
- Easy to change strategy globally
- Services retain flexibility for advanced users to override when needed

**Service flexibility:**

While policies provide the recommended path, services can offer override options for power users:

```nix
# Example: Blocky service with policy override
options.bigor.services.blocky = {
  followDnsPolicy = mkOption {
    type = types.bool;
    default = true;
    description = "Use DNS policy (true) or manual upstreams (false)";
  };
  upstreams = mkOption {
    type = types.listOf types.str;
    default = [];
    description = "Manual upstreams (only when followDnsPolicy = false)";
  };
};
```

Services should protect direct options with assertions that validate against policy computed values to ensure prerequisites are met.

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

- **One module per file** (`<name>.nix` format)
- **Group related modules** under feature categories
- **Keep host configs minimal** - use modules for reusability
- **Separate concerns** - system vs. home modules
- **Use directories only for multi-file modules** (like `nixvim/` with plugins)

### Module Options

- **Always provide descriptions** for options
- **Use appropriate types** (`types.bool`, `types.str`, etc.)
- **Provide sensible defaults** when appropriate
- **Document breaking changes** in commit messages

## Quality Standards

All contributions must:

1. Pass `nix fmt` (automatic formatting)
2. Pass `deadnix --fail .` (no dead code)
3. Pass `statix check --ignore .* .` (no lint errors)
4. Pass `nix flake check` (all automated checks)
5. Build successfully (`nh os build`)
6. Follow the module pattern
7. Include clear commit messages

## Getting Help

- **Check CLAUDE.md** for architecture details
- **Read existing modules** for examples
- **Test changes locally** before committing
- **Ask questions** in issues or discussions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
