# Contributing Guidelines

## Documentation Standards

This repository follows a **concise documentation style** to reduce verbosity while maintaining clarity.

### File Headers

Every `.nix` file must start with a 2-line header:

```nix
# <Type>: <name>
# Purpose: <one-line description>
```

**Types:**

- `System:` - Host configurations (`systems/`)
- `Profile:` - High-level feature bundles (`modules/nixos/profiles/`)
- `Feature:` - Individual capabilities (`modules/nixos/features/`)
- `Module:` - Services or libraries (`modules/nixos/services/`, `modules/nixos/lib/`)
- `Home:` - User configurations (`homes/`)
- `Flake:` - Main flake file

**Examples:**

```nix
# System: grospc
# Purpose: Desktop workstation with gaming optimizations

# Module: blocky
# Purpose: DNS proxy with ad/tracker blocking and local rewrites

# Feature: audio
# Purpose: PipeWire audio stack with ALSA and PulseAudio compatibility
```

### Inline Comments

**✅ DO comment:**

- Non-obvious logic or workarounds
- Security implications or warnings
- Complex algorithms
- Technical requirements (e.g., "checkReversePath = loose required for subnet routing")

**❌ DON'T comment:**

- Obvious operations (`enable = true;` doesn't need "Enable service")
- Information duplicated by variable names
- Self-documenting code

**Examples:**

```nix
# Good
boot.kernelParams = [ "amd_pstate=active" ]; # AMD P-State EPP active mode for better power management

# Bad (obvious)
services.ssh.enable = true; # Enable SSH server
```

### Code Formatting

- Use `nix fmt` before committing
- Keep lines under 100 characters where reasonable
- Group related configurations together
- Remove trailing whitespace

### Commit Messages

Follow conventional commits:

```
<type>: <short summary>

<optional body>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Types:** `feat`, `fix`, `docs`, `refactor`, `chore`, `test`

## Building and Testing

```bash
# Format code
nix fmt

# Check flake
nix flake check

# Build and switch configuration
nh os switch

# Build without switching
nh os build

# Update flake inputs
nix flake update

# Clean old generations
nh clean all
```

## Pull Requests

1. Ensure `nix flake check` passes
2. Run `nix fmt` on all modified files
3. Test builds on affected hosts
4. Keep PRs focused on a single concern
5. Update documentation if adding features

## Questions?

Check `CLAUDE.md` for architecture details and common patterns.
