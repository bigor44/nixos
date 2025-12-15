# Gemini Context: Bigor's NixOS Configuration

This project is a declarative NixOS configuration using **Flakes** and **Snowfall Lib**. It manages multiple systems (desktop and server) and user environments via Home Manager.

## 🏗 Architecture & Structure

The project follows the [Snowfall Lib](https://github.com/snowfallorg/lib) directory structure:

| Directory                          | Description                                                                             |
| :--------------------------------- | :-------------------------------------------------------------------------------------- |
| `systems/x86_64-linux/<host>`      | Host-specific configurations (e.g., `grospc`, `minipc`). Entry point for system builds. |
| `homes/x86_64-linux/<user>@<host>` | Home Manager configurations for specific users on specific hosts.                       |
| `modules/nixos`                    | Custom NixOS modules, namespaced under `bigor.*`.                                       |
| `modules/home`                     | Custom Home Manager modules, namespaced under `bigor.home.*`.                           |
| `packages`                         | Custom packages (overlays automatically applied).                                       |
| `scripts`                          | Maintenance and utility scripts.                                                        |

### Key Files

- `flake.nix`: The entry point. Defines inputs (nixpkgs, snowfall-lib, etc.) and outputs.
- `modules/nixos/roles/default.nix`: Defines high-level `bigor.roles` and default configurations per role.
- `treefmt.toml`: Configuration for the `treefmt` formatter (uses nixfmt, stylua, shfmt, etc.).

## 🛠 Usage & Workflows

### 1. Rebuilding the System

The preferred way to rebuild is using `nh` (Nix Helper).

```bash
# Apply changes to the current system
nh os switch

# Apply changes to a specific user (Home Manager)
# Usually handled automatically by NixOS module integration, but if standalone:
nh home switch
```

### 2. Modifying Configuration

- **Add a System Service**: Create `modules/nixos/services/<name>/default.nix`. Define `options.bigor.services.<name>.enable`. Add it to `modules/nixos/roles/default.nix` if it should be part of a standard role (like `homelab_master`).
- **Add a User App**: Edit `modules/home/gui-packages/default.nix` or `cli-packages/default.nix`.
- **Change Desktop Settings**: Look into `modules/nixos/desktop/cosmic` (DE), `modules/nixos/desktop/fonts`, or `modules/nixos/desktop/gaming`.
- **Monitoring**: Prometheus, Grafana, and Alertmanager are configured in `modules/nixos/services/monitoring`.

### 3. Adding a New Host

1.  Create `systems/x86_64-linux/<hostname>/`.
2.  Add `default.nix` (importing `hardware-configuration.nix`).
3.  Generate hardware config: `nixos-generate-config --show-hardware-config > systems/x86_64-linux/<hostname>/hardware-configuration.nix`.
4.  Set `bigor.roles` and `bigor.network` options in `default.nix`.

### 4. Code Quality

Always ensure code is formatted and checked before "committing" (completing a task).

```bash
# Format all files
treefmt

# Check for evaluation errors
nix flake check
```

## 🧩 conventions

- **Namespace**: All custom options are under `bigor.*` (System) or `bigor.home.*` (Home Manager).
- **Formatting**: `nixfmt` for Nix, `stylua` for Lua, `shfmt` for Shell. Run `treefmt`.
- **Secrets**: Currently using basic file management (no `sops-nix` or `agenix` observed yet, handle secrets with care).
- **Editors**: Neovim configuration is in `modules/home/nixvim`.