# ❄️ NixOS Configuration

Ce dépôt contient ma configuration système **NixOS** gérée avec **Flakes**. Elle est conçue pour être modulaire, reproductible et gère plusieurs machines avec des rôles distincts (Desktop & Serveur).

## 🏗️ Architecture du Projet

Le projet est structuré pour maximiser le partage de code entre les machines tout en gardant une configuration claire.

- **`flake.nix`** : Point d'entrée, définit les inputs (Nixpkgs, Home-Manager, NixVim, Antigravity...) et les outputs système.
- **`hosts/`** : Configurations spécifiques à chaque machine.
  - **`grospc`** : Station de travail principale (Gaming, Dev, Cosmic DE).
  - **`minipc`** : Serveur domestique (NAS, Monitoring, Dashboard).
- **`modules/`** : Modules réutilisables.
  - **`nixos/`** : Configuration système (Core, Desktop, Services).
  - **`home/`** : Configuration utilisateur (Home Manager, Shell, Git).

## 🖥️ Machines

| Hostname | Rôle | OS / Environnement | Services Clés |
| :--- | :--- | :--- | :--- |
| **`grospc`** | Desktop | NixOS / **Cosmic Alpha** | Steam, **Google Antigravity**, Gaming, Dev |
| **`minipc`** | Serveur | NixOS / Headless | NFS, AdGuard, Prometheus, Grafana, Homepage |

## ✨ Fonctionnalités Clés

### 🚀 Environnement de Bureau & Dev
- **Cosmic Desktop** : Utilisation de l'environnement de bureau Cosmic (System76) écrit en Rust.
- **Google Antigravity** : IDE "Agentic" nouvelle génération propulsé par Gemini 3, installé via Flake pour une isolation propre.
- **NixVim** : Configuration Neovim déclarative complète (LSP, Treesitter, Telescope, etc.).

### 📊 Services & Monitoring
- **Monitoring Stack** : 
  - **Node Exporter** sur toutes les machines.
  - **Prometheus & Grafana** centralisés sur le `minipc` pour l'agrégation et la visualisation.
- **AdGuard Home** : Filtrage DNS et bloquage de publicités réseau.
- **Homepage Dashboard** : Tableau de bord personnel regroupant tous les services du LAN.
- **Partage de fichiers** : Serveur NFS sur `minipc` monté automatiquement sur `grospc`.

## 🛠️ Installation et Utilisation

Pour appliquer la configuration sur une machine, clonez ce dépôt puis exécutez :

```bash
# Pour la station de travail (grospc)
nixos-rebuild switch --flake .#grospc

# Pour le serveur (minipc)
nixos-rebuild switch --flake .#minipc
````

### Mise à jour des dépendances

Pour mettre à jour le `flake.lock` (incluant Nixpkgs, Antigravity, etc.) :

```bash
nix flake update
```

## 📝 Conventions de Code

  - **Formatage** : Le code est formaté automatiquement via `alejandra`.
  - **Pre-commit** : Des hooks sont configurés pour vérifier la syntaxe et le style avant chaque commit.
  - **Options Centralisées** : Les fonctionnalités globales (ex: `monitoring.enable`, `system.role`) sont gérées via des options personnalisées dans `modules/nixos/core/options.nix`.

-----

*Configuration maintenue par [bigor44](https://www.google.com/search?q=https://github.com/bigor44)*

```

### Ce qui a changé dans cette version :
1.  **Tableau des machines :** Plus lisible pour comprendre d'un coup d'œil qui fait quoi.
2.  **Section Antigravity :** Mention explicite de votre nouvel IDE.
3.  **Détails techniques :** Ajout des détails sur la stack de monitoring et Cosmic.
4.  **Commandes utiles :** Ajout de la commande de mise à jour (`nix flake update`).
```
