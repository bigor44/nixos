
# ❄️ Bigor's NixOS Configuration

[](https://nixos.org)
[](https://nixos.wiki/wiki/Flakes)
[](https://system76.com/cosmic)

Bienvenue dans mon dépôt de configuration NixOS ("dotfiles"). Ce projet gère de manière déclarative l'ensemble de mes machines (Desktop & Serveur) en utilisant **Nix Flakes** et **Home-Manager**.

## 🖥️ Machines (Hosts)

| Hostname | Type | OS / Kernel | Rôle & Particularités |
| :--- | :--- | :--- | :--- |
| **grospc** | Desktop | NixOS Unstable (Zen Kernel) | Station de travail & Gaming. Environnement **Cosmic**, Optimisations CPU `performance`, Steam, Audio Pipewire. SSH désactivé. |
| **minipc** | Serveur | NixOS Unstable (Latest Kernel) | Homelab 24/7. Dashboard, AdGuard Home, SSH activé. Optimisations CPU `schedutil` (Eco). |

## 🗂️ Structure du dépôt

L'architecture est modulaire pour faciliter la maintenance :

```
.
├── flake.nix             # Point d'entrée, définition des inputs/outputs
├── hosts/                # Configurations spécifiques aux machines
│   ├── grospc/           # Hardware & configs pour le PC Principal
│   └── minipc/           # Hardware & configs pour le Mini PC
├── modules/
│   ├── home/             # Configuration utilisateur (Home-Manager)
│   │   ├── packages.nix  # Outils CLI (eza, fd, ripgrep...)
│   │   ├── shell.nix     # Config Fish & Plugins
│   │   └── git.nix       # Identité Git
│   └── nixos/            # Modules système partagés
│       ├── core/         # Config de base (Boot, Nix settings, Fonts, Users)
│       ├── desktop/      # Environnement graphique (Cosmic, Audio, Flatpak)
│       ├── nixvim/       # Configuration Neovim complète (Lua dans Nix)
│       └── services/     # Services auto-hébergés (AdGuard, Dashboard, SSH)
```

## 🚀 Fonctionnalités Clés

### 🐚 Shell & Terminal

Configuration avancée basée sur **Fish** :

  * **Prompt** : `bobthefisher`
  * **Outils modernes** : `eza` (remplace ls), `bat` (remplace cat), `ripgrep` (remplace grep), `zoxide` (navigation), `fzf`.
  * **Aliases pratiques** :
      * `ll` / `la` / `lt` : Variantes de listage avec icônes et infos git.
      * `gaa`, `gc`, `gp` : Raccourcis Git.
      * `ports`, `meminfo` : Monitoring rapide.

### 📝 Éditeur (Nixvim)

Neovim entièrement configuré via Nix (`nixvim`) avec le thème **TokyoNight** :

  * **LSP** : Support complet (Nil, Bash, Python, JSON, YAML).
  * **Formatage** : `alejandra` (nix), `shfmt` (bash), `marksman` (markdown).
  * **Plugins** : `neo-tree` (explorateur), `telescope` (recherche), `treesitter` (highlighting), `dap` (debug), `gitsigns`.
  * **Clavier** : Mappages intuitifs (`<leader>e` explorer, `<leader>ff` find files, etc.).

### 🌐 Services Hébergés (minipc)

  * **AdGuard Home** : Bloqueur de pub DNS et résolveur local.
      * Interface : `http://minipc.bigor.lan:3003`
      * DNS : Port 53 (UDP/TCP)
      * Rewrites configurés pour les domaines locaux `*.bigor.lan`.
  * **Homepage Dashboard** : Tableau de bord personnel.
      * Interface : `http://minipc.bigor.lan:8082`
      * Monitoring système (CPU, RAM, Disque) et liens rapides vers les services.

### 🎮 Desktop (grospc)

  * **Environnement** : Cosmic Desktop.
  * **Gaming** : Steam (avec Remote Play), Gamemode activé.
  * **Logiciels** : Firefox, Brave, Discord, Obsidian, Spotify/YouTube Music.
  * **Fonts** : Support étendu des polices Japonaises (Noto CJK, IPA) et Nerd Fonts.

## 🛠️ Installation & Utilisation

### Pré-requis

  * Une installation fraîche de NixOS.
  * Activer les Flakes expérimentalement si ce n'est pas déjà fait.

### Installation initiale

1.  Cloner le dépôt dans `~/nixos` (ou `/home/bigor/nixos`) :

    ```bash
    git clone https://github.com/TON_USER/TON_REPO ~/nixos
    cd ~/nixos
    ```

2.  Appliquer la configuration pour une machine spécifique (ex: `grospc`) :

    ```bash
    # Via l'outil nh (recommandé, inclus dans la config)
    nh os switch .

    # Ou via la commande classique
    sudo nixos-rebuild switch --flake .#grospc
    ```

### Maintenance

Le dépôt inclut un `devShell` avec des outils de qualité de code. Les hooks de pre-commit sont configurés pour formater et vérifier automatiquement le code avant chaque commit.

```bash
# Entrer dans le shell de développement
nix develop

# Les hooks s'exécuteront automatiquement lors de `git commit`.
# Pour les lancer manuellement sur tous les fichiers :
pre-commit run --all-files

# Pour formater manuellement tout le code :
nix fmt
```

## 👤 Auteur

**Yoann Bigor**

  * Configuré pour l'utilisateur : `bigor`
  * Timezone : `Europe/Paris`
  * Clavier : `fr`
