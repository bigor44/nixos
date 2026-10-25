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
│   │   ├── core.nix          # Boot, Nix, user, Home Manager, firewall
│   │   ├── locale.nix        # Locale, keyboard, fonts
│   │   ├── packages.nix      # Base CLI tools, nh (rebuild + GC)
│   │   ├── desktop.nix       # COSMIC, audio, Bluetooth, Flatpak, VIA, Steam
│   │   └── dev.nix           # Dev tools
│   └── home/                 # Home Manager modules (shell, git, apps, dotfiles)
└── dotfiles/                 # Raw configs symlinked by Home Manager
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
| `nrs`     | Flake check, then `nh os switch`                                |
| `nrb`     | Flake check, then `nh os boot`                                  |
| `nclean`  | `nh clean all` (also runs weekly)                               |

## Dotfiles

`dotfiles/` is symlinked out of the store (edits apply without a rebuild):

| Directory    | Description                        |
| ------------ | ---------------------------------- |
| `autostart/` | `.desktop` files launched at login |
| `cosmic/`    | COSMIC desktop settings            |
| `nvim/`      | Neovim configuration (Lua)         |

The generated `CosmicTheme.Dark`/`CosmicTheme.Light` directories are git-ignored; only the `*.Builder` themes are tracked.

## License

MIT, see [`LICENSE`](./LICENSE).
