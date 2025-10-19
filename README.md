# NixOS Dotfiles

Ce dépôt contient ma configuration NixOS, organisée de manière modulaire pour une installation reproductible et facile à maintenir sur plusieurs machines.

---

## 📌 Structure du dépôt

| Dossier/Fichier         | Description                                                                 |
|-------------------------|-----------------------------------------------------------------------------|
| `config/cosmic`         | Configuration spécifique à l’environnement de bureau [Cosmic](https://github.com/pop-os/cosmic) (Wayland). |
| `home/`                 | Configurations pour [home-manager](https://github.com/nix-community/home-manager) (dotfiles utilisateur). |
| `hosts/`                | Configurations spécifiques à chaque machine (ex : `nixos-config.nix`).     |
| `modules/`              | Modules NixOS réutilisables pour différentes fonctionnalités.              |
| `modules-disabled/`     | Modules désactivés ou en cours de développement.                           |
| `common.nix`            | Configuration commune à tous les hôtes.                                    |
| `desktop.nix`           | Configuration pour un environnement de bureau.                             |
| `server.nix`            | Configuration pour un serveur (sans interface graphique).                  |
| `flake.nix`             | Définition du flake Nix pour une gestion déclarative.                      |
| `home.nix`              | Configuration centrale pour home-manager.                                  |

---

## 🚀 Installation

### Prérequis
- Un système NixOS installé.
- [Flakes](https://nixos.wiki/wiki/Flakes) activés (ajoute `experimental-features = nix-command flakes` à `/etc/nixos/configuration.nix`).
- [home-manager](https://github.com/nix-community/home-manager) installé (optionnel, mais recommandé).

### Étapes
1. **Cloner le dépôt** :
   ```bash
   git clone https://gitlab.com/bigor44/nixos-dotfiles.git
   cd nixos-dotfiles
   ```

2. **Adapter la configuration** :
   - Copier ou créer un fichier pour ta machine dans `hosts/` (ex : `myhost.nix`).
   - Modifier les chemins et options selon ton matériel et tes besoins.

3. **Déployer** :
   ```bash
   sudo nixos-rebuild switch --flake .#<nom-de-ta-machine>
   ```
