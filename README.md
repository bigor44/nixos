# ❄️ NixOS Configuration

This repository contains my **NixOS** system configuration managed with **Nix Flakes**. It is designed to be modular, reproducible, and manages multiple machines with distinct roles (Desktop & Server).

## 🏗️ Project Architecture

The project is structured to maximize code sharing between machines while keeping the configuration clean and readable.

* **`flake.nix`**: Entry point defining inputs (Nixpkgs, Home-Manager, NixVim, Sops-Nix...) and system outputs.
* **`hosts/`**: Machine-specific configurations.
    * **`grospc`**: Main workstation (Gaming, Dev, Cosmic DE).
    * **`minipc`**: Home server (NAS, Monitoring, Dashboard, AdBlock).
* **`modules/`**: Reusable modules.
    * **`nixos/`**: System-level configuration (Core, Desktop, Services).
    * **`home/`**: User-level configuration via Home Manager (Shell, Git, Neovim).
* **`secrets/`**: Encrypted secrets managed by **sops-nix**.

## 🖥️ Hosts

| Hostname | Role | OS / Kernel | Key Features |
| :--- | :--- | :--- | :--- |
| **`grospc`** | Desktop | NixOS / Zen Kernel | Cosmic DE, Steam (Gaming), Pipewire, Bluetooth, NFS Client |
| **`minipc`** | Server | NixOS / Latest Kernel | Headless, AdGuard, Monitoring Stack, Vaultwarden, Tailscale Exit Node, NFS Server |

## ✨ Key Features

### 🚀 Desktop & Development Environment
* **Cosmic Desktop**: Running the alpha version of System76's Cosmic Desktop environment.
* **NixVim**: Fully declarative Neovim configuration featuring:
    * **Theme**: **Gruvbox** (hard contrast).
    * **LSP**: Native support for Nix, Bash, Markdown, JSON, YAML.
    * **Tools**: Telescope, Neo-tree, Gitsigns, Toggleterm, Which-key.
    * **Debug**: DAP enabled.
* **Shell**: Fish shell with plugins (bobthefisher, autopair, etc.), `eza` aliases, and **Bat** (configured with `gruvbox-dark` theme).

### 📊 Services & Infrastructure
* **Monitoring Stack**:
    * **Node Exporter**: Running on all nodes.
    * **Prometheus**: Centralized metric collection.
    * **Alertmanager**: Alert handling and routing.
    * **Grafana**: Data visualization with provisioned datasources (Prometheus & Alertmanager).
* **Homepage Dashboard**: A unified dashboard (`home.bigor.lan`) displaying system stats and service status (using `customapi` for Alertmanager).
* **AdGuard Home**: Network-wide ad blocking and local DNS rewriting (`*.bigor.lan`).
* **Networking**:
    * **Tailscale**: VPN with Exit Node capability enabled on `minipc`.
    * **Caddy**: Reverse proxy serving internal sites over HTTPS with local certificates.
* **Security**:
    * **Sops-nix**: Secret management using Age encryption.
    * **Hardened SSH**: Root login disabled, password authentication disabled.

## 🛠️ Installation & Usage

To apply the configuration to a specific host:

```bash
# For the workstation (grospc)
nixos-rebuild switch --flake .#grospc

# For the server (minipc)
nixos-rebuild switch --flake .#minipc
````

### Update Dependencies

To update `flake.lock` (including Nixpkgs, Home-Manager, etc.):

```bash
nix flake update
```

## 📝 Configuration Details

  * **Custom Options**: Global settings (e.g., `system.role`, `myNetwork.ips`) are defined in `modules/nixos/core/options.nix` to keep modules DRY (Don't Repeat Yourself).
  * **Formatting**: The codebase is automatically formatted using **Alejandra**.
  * **Pre-commit**: Hooks are configured to lint (Statix, Deadnix) and format code before committing.

## 📄 License

MIT License - 

```
