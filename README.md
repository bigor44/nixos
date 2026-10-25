# Bigor’s NixOS

Flake-based NixOS configuration (nixos-unstable, flake-parts, Home Manager) for my desktop workstation `grospc`, running COSMIC.

## Layout

```text
.
├── flake.nix                 # Inputs + nixosConfigurations.grospc
├── nix/checks.nix            # Formatters and linters (nix fmt, flake check)
├── hosts/grospc/             # Host entry point + hardware config
├── modules/
│   ├── nixos/                # System modules, imported by the host
│   │   ├── core.nix          # Boot, Nix, user, Home Manager, firewall
│   │   ├── locale.nix        # Locale, keyboard, fonts
│   │   ├── packages.nix      # Base CLI tools, nh (rebuild + GC)
│   │   ├── desktop.nix       # COSMIC, audio, Bluetooth, Steam
│   │   ├── gpu.nix           # AMD GPU compute: Vulkan, ROCm, OpenCL
│   │   └── ollama.nix        # Ollama server on the RX 7800 XT (ROCm)
│   └── home/                 # Home Manager modules, aggregated by default.nix
│       ├── shell.nix         # Fish, Starship, CLI tools
│       ├── git.nix           # Git, gh, git aliases
│       ├── dev.nix           # Toolchains, Neovim, Claude Code, OpenCode (Ollama)
│       ├── apps.nix          # Desktop applications
│       └── dotfiles.nix      # Out-of-store symlinks to dotfiles/
└── dotfiles/                 # Raw configs symlinked by Home Manager
```

## Commands

Formatters and linters run through `nix fmt` and `nix flake check` (no devshell, no git hook). The shortcuts are fish aliases (Home Manager), so they work in any shell:

| Command   | Description                                         |
| --------- | --------------------------------------------------- |
| `nix fmt` | Format and lint the repository (applies fixes)      |
| `qf`      | `nix flake check` (includes format and lint checks) |
| `gcn`     | Stage all, `nix fmt`, commit                        |
| `gps`     | Flake check, then push                              |
| `nrs`     | Flake check, then `nh os switch`                    |
| `nrb`     | Flake check, then `nh os boot`                      |
| `nclean`  | `nh clean all` (also runs weekly)                   |

## Dotfiles

`dotfiles/` is symlinked out of the store (edits apply without a rebuild), except `autostart/`, which is copied read-only into the store so apps cannot rewrite it:

| Directory    | Description                        |
| ------------ | ---------------------------------- |
| `autostart/` | `.desktop` files launched at login |
| `cosmic/`    | COSMIC desktop settings            |
| `nvim/`      | Neovim configuration (Lua)         |

The generated `CosmicTheme.Dark`/`CosmicTheme.Light` directories are git-ignored; only the `*.Builder` themes are tracked.

## License

MIT, see [`LICENSE`](./LICENSE).
