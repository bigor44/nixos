# ❄️ NixOS Configuration

This repository contains my personal **NixOS** system configurations, managed with **Nix Flakes** and **Home Manager**. It is designed to maintain consistent, reproducible environments across my desktop and server infrastructure.

## 🖥️ Hosts

| Hostname     | Role       | Description                                                                                                        |
| :----------- | :--------- | :----------------------------------------------------------------------------------------------------------------- |
| **`grospc`** | 🖥️ Desktop | Main workstation. Features **COSMIC** and **KDE Plasma 6**, gaming setup (Steam, GameMode), and development tools. |
| **`minipc`** | 🏠 Server  | Home lab server. Hosts services like **AdGuard Home**, **Vaultwarden**, **Caddy**, and **Homepage Dashboard**.     |

## ⚙️ Key Features

- **Nix Flakes & Home Manager**: Purely functional dependency management and dotfile configuration.
- **Secrets Management**: securely managed via **sops-nix** and **age** encryption.
- **Desktop Environment**: Custom configuration for System76's **COSMIC DE** (alpha) with specific theming (Dark/Light modes) and panel layouts.
- **Shell Environment**: **Fish** shell integrated with **Starship** prompt, **zoxide**, **fzf**, and **eza** for a modern terminal experience.
- **Neovim**: A robust, Lua-based Neovim configuration featuring **Lazy.nvim**, **LSP** (nixd, lua_ls, pyright), **Treesitter**, **Mini.nvim**, and **Catppuccin** theme.
- **Services**:
  - **Reverse Proxy**: Caddy handling SSL for internal services (`*.bigor.lan`).
  - **Security**: AdGuard Home for DNS filtering and Vaultwarden for password management.
  - **Networking**: Tailscale for secure remote access and NFS for shared storage.
  - **Dashboard**: Homepage dashboard for service monitoring.

## 📂 Project Structure

```text
├── certs/                  # Local CA certificates
├── hosts/                  # Host-specific hardware and boot configurations
│   ├── grospc/
│   └── minipc/
├── modules/
│   ├── home/               # Home Manager modules (User configuration)
│   │   ├── dotfiles/       # Config files linked out-of-store (nvim, cosmic, etc.)
│   │   └── ...             # Shell, Git, Neovim, etc.
│   └── nixos/              # System-wide NixOS modules
│       ├── core/           # Base settings (users, locale, packages)
│       ├── desktop/        # GUI related settings (audio, fonts, flatpak)
│       ├── roles/          # Profiles: desktop, server, hybrid
│       └── services/       # Server services definitions
├── scripts/                # Utility scripts (e.g., config concatenator)
├── secrets/                # Encrypted secrets (secrets.yaml)
├── flake.nix               # Entry point and dependency definitions
└── flake.lock              # Lockfile for reproducible builds
```

````

## 🚀 Usage

### bootstrap or Update

To apply the configuration for a specific host:

```bash
# Switch configuration for the current hostname
sudo nixos-rebuild switch --flake .

# Or target a specific host
sudo nixos-rebuild switch --flake .#grospc
sudo nixos-rebuild switch --flake .#minipc
```

### Secrets

Secrets are encrypted using `sops`. To edit secrets, you need the appropriate `age` key:

```bash
sops secrets/secrets.yaml
```

### Development

This flake includes a dev shell with pre-configured linters and formatters (`nixfmt`, `stylua`, `deadnix`, `statix`).

```bash
nix develop
# or automatically via direnv if configured
```

## 🛠️ Tooling & Credits

- **Operating System**: [NixOS](https://nixos.org/)
- **Package Manager**: [Nix](https://www.google.com/search?q=https://nixos.org/manual/nix/stable/)
- **User Environment**: [Home Manager](https://github.com/nix-community/home-manager)
- **Editor**: [Neovim](https://neovim.io/)
- **Theme**: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin)

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

```
````
