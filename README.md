# Bigor's NixOS Flake Configuration

This repository contains my personal NixOS flake configuration, designed to manage system and user environments across multiple machines (`grospc` and `minipc`). It leverages NixOS for declarative system management and Home Manager for user-specific configurations, ensuring a consistent and reproducible development and operating environment.

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs (Nixpkgs, Home Manager) and outputs (System Configurations).
- **`hosts/`**: Machine-specific configurations.
  - **`grospc/`**: High-performance Desktop.
    - **Channel**: `nixos-25.11` (Stable)
    - **Key Modules**: `roles.desktop` (COSMIC), `nfs.client`, `sshd.enable`.
    - **Hardware**: AMD CPU/GPU, Zen Kernel.
  - **`minipc/`**: Home Server / Lab.
    - **Channel**: `nixos-25.11` (Stable)
    - **Key Modules**: `roles.homelab_master` (Headless), `nfs.server`, `sshd.enable`.
    - **Networking**: Tailscale optimization (UDP GRO enabled).
- **`modules/`**: Reusable configuration logic.
  - **`nixos/`**: System-level modules (root).
    - **`core/`**: System defaults, locale, users, `options.nix` (feature flags).
    - **`desktop/`**: GUI environment (COSMIC), Audio (Pipewire), Fonts, Gaming.
    - **`services/`**:
      - **Infrastructure**: NFS, Tailscale, SSH.
      - **Applications**: AdGuard, Caddy, Dashboard (Homepage), Glances (Monitoring).
  - **`home/`**: User-level modules (Home Manager for user `bigor`).
    - **`dotfiles.nix`**: Symlink management for files in `dotfiles/`.
    - **`packages.nix`**: User CLI/GUI packages.
    - **`shell.nix`**: Shell configuration (Fish, Starship, tools).
    - **`git.nix`**: Git configuration.
    - **`neovim.nix`**: Neovim configuration.
    - **`turtle-wow.nix`**: Turtle WoW game client wrapper (AppImage + Wayland fixes).
- **`dotfiles/`**: Raw config files (symlinked).
  - `cosmic/`, `nvim/`, `autostart/`.
- **`scripts/`**: Utility scripts (e.g., `concat_config.sh`).

## Custom Options API

These options are defined in `modules/nixos/core/options.nix` and act as high-level feature flags to control the system configuration.

| Option                     | Description                                                                      |
| :------------------------- | :------------------------------------------------------------------------------- |
| **`roles.desktop`**        | Enables full graphical environment (COSMIC), audio, fonts, and workstation apps. |
| **`roles.homelab_master`** | Enables headless server services, container orchestration, and monitoring.       |
| **`sshd.enable`**          | Enables hardened OpenSSH server (no root login, key-based auth).                 |
| **`nfs.server`**           | Exports `/mnt/storage` via NFS.                                                  |
| **`nfs.client`**           | Mounts the shared NFS storage.                                                   |
| **`myNetwork.ips`**        | Defines static IPs for `grospc` and `minipc`.                                    |
| **`myNetwork.mainInterface`**| Defines the primary network interface (e.g., `enp2s0`).                        |

## Installation

To set up a new machine with this configuration:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Bigor/nixos.git ~/.config/nixos # Adjust path as needed
    cd ~/.config/nixos
    ```
2.  **Edit `flake.nix` (if necessary):**
    You might need to adjust the `hosts` section in `flake.nix` to match your new machine's hostname or specific requirements.
3.  **Apply the configuration:**
    It is recommended to use `nh` (Nix Helper) for applying configurations, as it provides better generation management and cleaning than raw `nixos-rebuild`.

    For the current host:
    ```bash
    nh os switch
    ```
    For a remote host (e.g., `minipc`):
    ```bash
    nh os switch -H minipc
    ```

## Usage

### Managing Hosts

Configurations for different machines are located under the `hosts/` directory. Each host has its own `default.nix` and `hardware-configuration.nix`.

### Updating Flake Inputs

To update the upstream dependencies (e.g., Nixpkgs, Home Manager) defined in `flake.nix`:

```bash
nix flake update
```

## Contributing

Contributions are welcome! Please ensure your changes adhere to the existing code style and pass all quality checks.

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes.
4.  Run code quality checks:
    ```bash
    nix develop               # Enter dev shell
    treefmt                   # Format code
    nix build .#checks.x86_64-linux.pre-commit-check # Run linters
    ```
5.  Submit a pull request.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.