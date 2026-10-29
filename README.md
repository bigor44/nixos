# Bigor’s NixOS

Flake-based NixOS configuration (nixos-unstable, flake-parts, Home Manager, nixvim) for my desktop workstation `grospc`, running COSMIC.

## Layout

```text
.
├── flake.nix                 # Inputs + nixosConfigurations.grospc
├── nix/checks.nix            # Formatters and linters (nix fmt, flake check)
├── hosts/grospc/             # Host entry point, machine-specific settings (kernel, AMD GPU, Pi-hole DNS) + hardware config
├── modules/
│   ├── nixos/                # System modules, imported by the host
│   │   ├── core.nix          # Boot, fwupd, Nix, nh + Nix abbreviations, user, locale, fonts
│   │   ├── packages.nix      # Base CLI tools
│   │   ├── shell.nix         # Fish, Starship, CLI tools, aliases
│   │   ├── dev.nix           # Git, gh, toolchains, Claude Code
│   │   ├── nixvim.nix        # Neovim via nixvim: tokyonight, mini.nvim, LSP (nixd, bashls, fish-lsp)
│   │   ├── desktop.nix       # COSMIC, graphics, network, audio, Bluetooth, apps
│   │   ├── gaming.nix        # Steam, Proton-GE, Lutris, CurseForge, GameMode, MangoHud, DualSense…
│   │   └── home.nix          # Home Manager as a NixOS module (user bigor)
│   └── home/                 # Home Manager modules (user-specific only), aggregated by default.nix
│       ├── git.nix           # Git identity
│       └── dotfiles.nix      # Out-of-store symlinks to dotfiles/
└── dotfiles/                 # Raw configs symlinked by Home Manager
```

## Commands

Formatters and linters run through `nix fmt` and `nix flake check` (no devshell, no git hook). The shortcuts are system-wide fish abbreviations (`modules/nixos/core.nix`):

| Command   | Description                                           |
| --------- | ----------------------------------------------------- |
| `nix fmt` | Format (rewrites files) and lint (reports only)       |
| `qf`      | `nix flake check` (includes format and lint checks)   |
| `gps`     | Flake check, then push                                |
| `nrs`     | Flake check, then `nh os switch` (incl. Home Manager) |
| `nrb`     | Flake check, then `nh os boot`                        |
| `nclean`  | `nh clean all` (also runs weekly)                     |

## Dotfiles

`dotfiles/` is symlinked out of the store (edits apply without a rebuild), except `autostart/`, which is copied read-only into the store so apps cannot rewrite it:

| Directory    | Description                        |
| ------------ | ---------------------------------- |
| `autostart/` | `.desktop` files launched at login |
| `cosmic/`    | COSMIC desktop settings            |

The generated `CosmicTheme.Dark`/`CosmicTheme.Light` directories are git-ignored; only the `*.Builder` themes are tracked.

## License

MIT, see [`LICENSE`](./LICENSE).
