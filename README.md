# Projet de Configuration NixOS

## Aperçu du Projet

Ce dépôt contient une configuration NixOS complète et déclarative gérée avec Nix Flakes. Il est conçu pour être reproductible et modulaire, supportant plusieurs machines hôtes (`grospc` et `minipc`). La configuration inclut des paramètres au niveau du système, des environnements spécifiques à l'utilisateur via `home-manager`, et des personnalisations détaillées pour l'environnement de bureau Cosmic.

Le cœur du projet est l'approche modulaire, avec différentes fonctionnalités réparties dans des fichiers séparés sous le répertoire `modules/`. Cela facilite la gestion et l'activation/désactivation de fonctionnalités telles que l'audio, le Bluetooth, diverses applications et services.

## Construction et Exécution

Pour appliquer la configuration à un système NixOS, vous devez avoir Nix Flakes activé. La commande principale pour construire et basculer vers une nouvelle configuration est :

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Remplacez `<hostname>` par l'hôte cible pour lequel vous souhaitez construire (par exemple, `grospc` ou `minipc`).

**Commandes Courantes :**

*   **Appliquer la configuration :** `sudo nixos-rebuild switch --flake .#<hostname>`
*   **Mettre à jour les entrées flake :** `nix flake update`
*   **Vérifier le flake :** `nix flake check`

## Structure du Projet

*   `flake.nix` : Le point d'entrée pour le Nix Flake. Il définit les entrées du projet (comme `nixpkgs` et `home-manager`) et produit les `nixosConfigurations` finales pour chaque hôte.
*   `configuration.nix` : Le fichier de configuration principal à l'échelle du système. Il importe les modules NixOS du répertoire `modules/nixos/`.
*   `home.nix` : Le fichier de configuration principal de `home-manager`. Il importe les modules spécifiques à l'utilisateur du répertoire `modules/home/`.
*   `hosts/` : Ce répertoire contient les configurations spécifiques à l'hôte. Chaque sous-répertoire correspond à une machine et inclut des paramètres spécifiques au matériel.
*   `modules/` : Ce répertoire contient les configurations modularisées :
    *   `modules/nixos/` : Contient les modules NixOS pour les configurations à l'échelle du système. Ceux-ci incluent `adguard.nix`, `desktop.nix`, `network.nix`, `nixvim.nix`, `options.nix`, `packages.nix`, `sshd.nix`, `system.nix`, et `users.nix`.
    *   `modules/nixos/nixvim/` : Contient les modules pour configurer nixvim. Ceux-ci incluent `keymaps.nix`, `options.nix`, et `plugins.nix`.
    *   `modules/home/` : Contient les modules home-manager pour les configurations spécifiques à l'utilisateur. Ceux-ci incluent `git.nix`, `packages.nix`, et `shell.nix`.
*   `config/cosmic/` : Ce répertoire contient les paramètres pour l'environnement de bureau Cosmic, qui sont gérés en dehors de la configuration NixOS mais font partie de la configuration globale.

## Conventions de Développement

*   **Modifications Déclaratives :** Toutes les configurations système et utilisateur sont gérées de manière déclarative dans les fichiers `.nix`. Pour apporter des modifications, vous modifiez ces fichiers puis reconstruisez le système.
*   **Modularité :** Les nouvelles fonctionnalités ou configurations doivent être ajoutées en tant que nouveaux modules dans les répertoires `modules/nixos` ou `modules/home`, puis importées respectivement dans `configuration.nix` ou `home.nix`.
*   **Paramètres Spécifiques à l'Hôte :** Toute configuration unique à une seule machine doit être placée dans le fichier correspondant du répertoire `hosts/`.
*   **Paramètres Spécifiques à l'Utilisateur :** Les paquets et configurations au niveau de l'utilisateur sont gérés dans `home.nix` à l'aide de `home-manager`.
