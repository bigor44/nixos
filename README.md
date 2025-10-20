# nixos — Personal Nix / NixOS configuration

[Repository](https://github.com/bigor44/nixos) · See LICENSE

This repository contains a personal Nix/NixOS configuration using flakes and a home-manager layout. It includes system-level NixOS configurations for multiple hosts, reusable modules, Home Manager configurations, and a set of desktop settings exported for Cosmic (System76).

Quick overview
- Flake-based repository (flake.nix + flake.lock included).
- Hosts: grospc, minipc (each has a hardware-configuration.nix and a host configuration).
- Home Manager: top-level home.nix and per-feature files in `home/` (git.nix, nvim.nix, vscode.nix, zsh.nix).
- Reusable modules in `modules/` and some disabled modules in `modules-disabled/`.
- Desktop UI settings exported under `config/cosmic/`.

Table of contents
- Quickstart
- Hosts
- Home manager
- Repo layout
- Common operations
- Development & testing
- Secrets & sensitive data
- CI, caching & deployment
- Contributing
- License & contact

Quickstart (recommended: flakes)
1. Ensure you have Nix installed with flakes enabled. See https://nixos.org/manual/nix/stable/ for install steps.
2. To list flake outputs locally:
   - nix flake show .
   - or: nix flake show github:bigor44/nixos
3. To build or apply a host configuration (examples for hosts present in this repo):
   - Build a host system:
     - nix build .#nixosConfigurations.grospc.config.system.build.toplevel
   - Switch to a host config (apply):
     - sudo nixos-rebuild switch --flake .#grospc
     - sudo nixos-rebuild switch --flake .#minipc
   - If your flake exposes top-level system names, you can also use: sudo nixos-rebuild switch --flake .#<host-name>

Non-flake / legacy usage
- If you prefer non-flake workflows, you can copy the relevant configuration files into /etc/nixos and run `nixos-rebuild` the usual way, but this repo is organized around flakes.

Hosts
- hosts/grospc
  - grospc.nix
  - hardware-configuration.nix
- hosts/minipc
  - minipc.nix
  - hardware-configuration.nix

Each host configuration imports modules from `modules/` and sets host-specific options. The included hardware-configuration.nix files mean these hosts can be rebuilt directly on the machine.

Home Manager
- home.nix — top-level entry for home-manager.
- home/git.nix, home/nvim.nix, home/vscode.nix, home/zsh.nix — feature files used or imported by home.nix.

Modules
The `modules/` directory contains modularized system/service configuration. Current module files:
- adguard.nix
- audio.nix
- base-apps.nix
- bluetooth.nix
- boot.nix
- desktop-apps.nix
- desktop-env.nix
- flatpak.nix
- fonts.nix
- gc.nix
- locale.nix
- network.nix
- options.nix
- ssh.nix
- users.nix

Disabled modules
- modules-disabled/home-assistant.nix
- modules-disabled/podman.nix

Desktop exported settings
- config/cosmic/ — contains exported keys for System76 Cosmic desktop (panels, theme, apps, etc.). These are useful for reproducing desktop preferences.

License
- See LICENSE at the repository root for licensing details.

Maintainer / contact
- Maintainer: @bigor44
- Repo: https://github.com/bigor44/nixos
