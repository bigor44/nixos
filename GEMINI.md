# Gemini Project Analysis: NixOS Configuration

## Project Overview

This repository contains a complete NixOS configuration for multiple machines, managed using Nix Flakes. It demonstrates a robust, modular, and reproducible approach to system management, treating infrastructure as code.

The configuration manages at least two distinct machines:
*   **`grospc`**: A desktop machine.
*   **`minipc`**: A server.

The project is architected with a strong separation of concerns:
*   **Flake Entrypoint (`flake.nix`):** Defines all inputs (like `nixpkgs`, `home-manager`, `sops-nix`) and orchestrates the assembly of system configurations.
*   **Modular Configuration (`modules/`):**
    *   **System-level (`nixos/`):** Contains NixOS modules for system-wide settings, services, and hardware. It uses a role-based system (`desktop`, `server`) to apply configurations conditionally.
    *   **User-level (`home/`):** Contains user-specific configurations managed by `home-manager`, such as shell setup, dotfiles, and user packages.
*   **Machine-specific (`hosts/`):** Each machine has a dedicated directory containing its hardware configuration and top-level settings, like its assigned role.
*   **Secrets Management:** Secrets are managed declaratively and securely using `sops-nix`, with encrypted files stored in the `secrets/` directory.

Key technologies used:
*   **NixOS:** The declarative Linux distribution.
*   **Nix Flakes:** For reproducible builds and dependency management.
*   **Home Manager:** To manage user environments declaratively.
*   **sops-nix:** For encrypting and decrypting secrets.

## Building and Running

The primary way to manage a system with this configuration is through the `nixos-rebuild` command, targeting a specific host defined in the `flake.nix`.

**Apply Configuration:**
To build and activate the configuration for a specific machine, run the following command on the target machine:

```bash
# Example for the 'grospc' desktop
nixos-rebuild switch --flake .#grospc

# Example for the 'minipc' server
nixos-rebuild switch --flake .#minipc
```

**Update Dependencies:**
To update all flake inputs (like `nixpkgs`) to their latest versions, run:

```bash
nix flake update
```

**Development Shell:**
The project provides a development shell with tools for formatting and checking Nix code. To enter this environment, run:
```bash
nix develop
```

## Development Conventions

*   **Modularity:** The configuration is highly modular. New features or services are typically added as new modules in the `modules/` directory. These modules are then enabled for specific hosts via custom options.
*   **Role-Based Configuration:** A custom option `system.role` is used to assign a role (e.g., "desktop", "server") to each machine. This role is then used to conditionally apply large sets of related configurations.
*   **Declarative Secrets:** Secrets are not stored in plain text. They are encrypted using `sops` and decrypted on the target machine by `sops-nix`, allowing the entire configuration, including secrets, to be stored in a git repository.
*   **Code Style:** The codebase is formatted using `nixfmt-rfc-style`. Pre-commit hooks are configured to ensure code is linted (`statix`, `deadnix`) and formatted before being committed.
