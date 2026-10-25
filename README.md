# Bigor’s NixOS

Flake-based NixOS configuration (nixos-unstable, flake-parts, Home Manager) for my desktop workstation `grospc`, running COSMIC.

## Layout

```text
.
├── flake.nix                 # Inputs + nixosConfigurations.grospc
├── nix/devshell.nix          # Formatter, pre-commit hooks, dev shell
├── hosts/grospc/             # Host entry point + hardware config
├── modules/
│   ├── nixos/                # System modules, imported by the host
│   │   ├── core.nix          # Boot, Nix, user, firewall
│   │   ├── locale.nix        # Locale, keyboard, fonts
│   │   ├── packages.nix      # Base CLI tools
│   │   ├── desktop.nix       # COSMIC, audio, Bluetooth, Flatpak, VIA
│   │   ├── gaming.nix        # Steam, GameMode
│   │   ├── dev.nix           # Dev tools
│   │   └── home-manager.nix  # Home Manager integration
│   └── home/                 # Home Manager modules (shell, git, apps, dotfiles)
├── dotfiles/                 # Raw configs symlinked by Home Manager
└── scripts/
```

## Commands

`nix develop` installs the pre-commit hook and provides the QA tools. The shortcuts are zsh aliases (Home Manager), so they work in any shell:

| Command   | Description                                                     |
| --------- | --------------------------------------------------------------- |
| `nix fmt` | Format the repository (treefmt)                                 |
| `qc`      | Run pre-commit (treefmt, statix, deadnix, shellcheck, luacheck) |
| `qf`      | `nix flake check` (includes the pre-commit checks)              |
| `gcn`     | Stage all, run pre-commit, commit                               |
| `gps`     | Flake check, then push                                          |
| `nrs`     | Flake check, then `nixos-rebuild switch`                        |
| `nrb`     | Flake check, then `nixos-rebuild boot`                          |

## Dotfiles

`dotfiles/` is symlinked out of the store (edits apply without a rebuild):

| Directory    | Description                        |
| ------------ | ---------------------------------- |
| `autostart/` | `.desktop` files launched at login |
| `cosmic/`    | COSMIC desktop settings            |
| `nvim/`      | Neovim configuration (Lua)         |

## Scripts

- `scripts/concat_config.sh [out.md]` concatenates the configuration into a single Markdown file for sharing.

## License

MIT, see [`LICENSE`](./LICENSE).
