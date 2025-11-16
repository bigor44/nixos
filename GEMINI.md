# Project Overview

This repository contains the NixOS configuration for two machines: `grospc` and `minipc`. It uses flakes and is structured with modules for NixOS, home-manager, and nixvim.

## Key Technologies

*   **NixOS:** A Linux distribution with a declarative configuration model.
*   **Nix Flakes:** A new, more reproducible way to manage Nix expressions.
*   **home-manager:** A tool to manage a user's environment declaratively.
*   **nixvim:** A module for configuring Neovim with Nix.

## Building and Running

To build and apply the configuration for a specific host, use the following command:

```bash
nixos-rebuild switch --flake .#<hostname>
```

For example, to build and apply the configuration for `grospc`:

```bash
nixos-rebuild switch --flake .#grospc
```

## Development Conventions

*   The configuration is modular, with different concerns separated into different files.
*   NixOS modules are located in `modules/nixos`.
*   home-manager modules are located in `modules/home`.
*   Host-specific configurations are in `hosts/<hostname>`.
