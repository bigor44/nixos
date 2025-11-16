# Bigor’s NixOS Flake

Opinionated, fully-declarative NixOS configuration for two machines:

* **grospc** – desktop / gaming workstation (AMD, COSMIC DE, ROCm, Steam …)  
* **minipc** – headless home-lab server (AMD, Ollama, NFS, SSH, AdGuard …)

Both share the same flake, user (`bigor`), fish shell, and home-manager setup.

---

## 1. Folder Map

```
.
├── flake.nix                 # Entry point – builds both hosts
├── hosts/
│   ├── grospc/               # Desktop machine
│   └── minipc/               # Server machine
├── modules/
│   ├── nixos/                # System-wide modules
│   └── home/                 # Home-manager (user) modules
└── README.md                 # This file
```

---

## 2. Quick Start

```bash
# Clone
git clone https://github.com/bigor44/nixos ~/nixos
cd ~/nixos

# Update lockfile (optional)
nix flake update

# Build & switch
sudo nixos-rebuild switch --flake .#grospc   # or .#minipc
```

Fish abbreviations are already configured:

| Abbrev | Command |
|--------|---------|
| `nrs`  | `sudo nixos-rebuild switch --flake ~/nixos` |
| `nfu`  | `nix flake update` |
| `ncg`  | `sudo nix-collect-garbage -d` |

---

## 3. Host Profiles

| Feature | grospc (desktop) | minipc (server) |
|---------|------------------|-----------------|
| Desktop | COSMIC (Wayland) | ❌ |
| Audio   | PipeWire         | ❌ |
| Bluetooth | ✔              | ❌ |
| GPU     | ROCm / OpenCL    | — |
| Gaming  | Steam + gamemode | ❌ |
| LLM     | ❌               | Ollama (ROCm) |
| NFS     | client           | server (share `/mnt/storage`) |
| AdGuard | ✔                | ✔ |
| SSH     | ❌               | ✔ (key-only) |

---

## 4. Networking

* LAN domain: `bigor.lan`
* DNS: AdGuard on each host (port 53) → upstream DoH
* Static leases via router (192.168.1.1)

| Host    | IP            | Names |
|---------|---------------|-------|
| grospc  | 192.168.1.1   | `grospc` `grospc.bigor.lan` |
| minipc  | 192.168.1.10  | `minipc` `minipc.bigor.lan` `*.bigor.lan` |

---

## 5. Shared Software

* Shell: fish + fzf + zoxide + bobthefisher
* Editor: nixvim (Neovim) – LSP, telescope, dap, gitsigns …
* CLI: eza, bat, ripgrep, fd, btop, htop, alejandra, …
* Fonts: JetBrains-Nerd, Terminus, Powerline

---

## 6. Secrets / TODO

* No secret management yet – place secrets in `/etc/nixos/secrets.nix` and import manually
* Consider sops-nix or agenix for next iteration

---

## 7. License

MIT – do whatever you want.
