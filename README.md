# Bigor's NixOS Flake Configuration

This repository contains my personal NixOS flake configuration, designed to manage system and user environments across multiple machines (`grospc` and `minipc`). It leverages NixOS for declarative system management and Home Manager for user-specific configurations, ensuring a consistent and reproducible development and operating environment.

## Project Structure

- **`flake.nix`**: The entry point. Defines inputs (Nixpkgs, Home Manager) and outputs (System Configurations).
- **`systems/`**: Machine-specific configurations.
  - **`x86_64-linux/`**:
    - **`grospc/`**: High-performance Desktop.
      - **Channel**: `nixos-25.11` (Stable)
      - **Key Modules**: `bigor.roles.desktop` (COSMIC), `bigor.services.nfs.client`, `bigor.services.ssh.enable`.
      - **Hardware**: AMD CPU/GPU, Zen Kernel.
    - **`minipc/`**: Home Server / Lab.
      - **Channel**: `nixos-25.11` (Stable)
      - **Key Modules**: `bigor.roles.homelab_master` (Headless), `bigor.services.nfs.server`, `bigor.services.ssh.enable`.
      - **Networking**: Tailscale optimization (UDP GRO enabled).
    - **`modules/`**: Reusable configuration logic.
      - **`nixos/`**: System-level modules (root).
        - **`core/`**: System defaults, locale, users, `options.nix` (feature flags).
        - **`desktop/`**: GUI environment (COSMIC), Audio (Pipewire), Fonts, Gaming.
        - **`services/`**:
          - **Infrastructure**: NFS, Tailscale, SSH.
          - **Applications**: AdGuard, Caddy, Dashboard (Homepage), Glances (Monitoring).
          - **Pattern**: Services are self-contained. They define their own Caddy `virtualHosts` and AdGuard `rewrites` within their own `.nix` file using `services.caddy.virtualHosts` and `services.adguardhome.settings.filtering.rewrites`.
      - **`home/`**: User-level modules (Home Manager for user `bigor`).
        - **`dotfiles.nix`**: Symlink management for files in `dotfiles/`.
        - **`packages.nix`**: User CLI/GUI packages.
        - **`shell.nix`**: Shell configuration (Fish, Starship, tools).
        - **`git.nix`**: Git configuration.
        - **`turtle-wow.nix`**: Turtle WoW game client wrapper (AppImage + Wayland fixes).
    - **`dotfiles/`**: Raw config files (symlinked).
      - `cosmic/`, `autostart/`.
    - **`scripts/`**: Utility scripts (e.g., `concat_config.sh`).

    ## Custom Options API

    These options are defined in `modules/nixos/core/options.nix` and act as high-level feature flags to control the system configuration.

    | Option                            | Description                                                                      |
    | :-------------------------------- | :------------------------------------------------------------------------------- | --- | ----------------------- | --------------------------------------------- |
    | **`bigor.roles.desktop`**         | Enables full graphical environment (COSMIC), audio, fonts, and workstation apps. |
    | **`bigor.roles.homelab_master`**  | Enables headless server services, container orchestration, and monitoring.       |
    | **`bigor.services.ssh.enable`**   | Enables hardened OpenSSH server (no root login, key-based auth).                 |
    | **`bigor.services.nfs.server`**   | Exports `/mnt/storage` via NFS.                                                  |
    | **`bigor.services.nfs.client`**   | Mounts the shared NFS storage.                                                   |     | **`bigor.network.ips`** | Defines static IPs for `grospc` and `minipc`. |
    | **`bigor.network.mainInterface`** | Defines the primary network interface (e.g., `enp2s0`).                          |

## Development Workflow

### 1. Apply Changes

Use `nh` (Nix Helper) for best results. It handles generation management and cleaning better than raw `nixos-rebuild`.

```bash
nh os switch              # Apply to current host
nh os switch -H minipc    # Apply to remote host
```

### 2. Dependency Management

```bash
nix flake update          # Update lockfile with new inputs
```

### 3. Code Quality & Commit Hooks

This project uses `git-hooks` to ensure code quality and consistency.

**Automatic Setup:**
When you enter the development shell, the git hooks are automatically installed:

```bash
nix develop
```

**Manual Execution:**
You can run the full suite of checks manually at any time:

```bash
nix build .#checks.x86_64-linux.git-hooks-check
```

**Enabled Checks:**

- **`statix` & `deadnix`**: Lints and checks for unused code in Nix files.
- **`luacheck`**: Lints Lua configuration files (e.g., Neovim).
- **`typos`**: Checks for spelling errors across the codebase.
- **`commitizen`**: Enforces [Conventional Commits](https://www.conventionalcommits.org/) standards for commit messages.

### 4. AI-Assisted Commits

A custom Fish shell function `gai` (Git AI) is available to generate conventional commit messages using the Gemini CLI.

**Usage:**

1. Stage your changes: `git add ...`
2. Run the assistant: `gai`
3. Review the generated message and confirm to commit.

### 5. Contributing

Contributions are welcome! Please ensure your changes adhere to the existing code style and pass all quality checks.

#### Code Style & Documentation

- **Language:** Use English for all comments and documentation.
- **Comments:** Focus on _why_ a configuration exists, not just _what_ it does.
- **Nix Style:** Follow the formatting enforced by `treefmt` (Alejandra).

#### Workflow

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes.
4.  Run code quality checks (see above).
5.  Submit a pull request.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.
