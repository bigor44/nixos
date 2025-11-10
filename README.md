# NixOS Configuration Project

## Project Overview

This repository contains a complete, declarative NixOS configuration managed using Nix Flakes. It's designed to be reproducible and modular, supporting multiple host machines (`grospc` and `minipc`). The configuration includes system-level settings, user-specific environments via `home-manager`, and detailed customizations for the Cosmic desktop environment.

The core of the project is the modular approach, with different functionalities split into separate files under the `modules/` directory. This makes it easy to manage and toggle features like audio, Bluetooth, various applications, and services.

## Building and Running

To apply the configuration to a NixOS system, you need to have Nix Flakes enabled. The primary command to build and switch to a new configuration is:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Replace `<hostname>` with the target host you want to build for (e.g., `grospc` or `minipc`).

**Common Commands:**

*   **Apply the configuration:** `sudo nixos-rebuild switch --flake .#<hostname>`
*   **Update flake inputs:** `nix flake update`
*   **Check the flake:** `nix flake check`

## Project Structure

*   `flake.nix`: The entry point for the Nix Flake. It defines the project's inputs (like `nixpkgs` and `home-manager`) and outputs the final `nixosConfigurations` for each host.
*   `configuration.nix`: The main system-wide configuration file. It imports NixOS modules from the `modules/nixos/` directory.
*   `home.nix`: The main `home-manager` configuration file. It imports user-specific modules from the `modules/home/` directory.
*   `hosts/`: This directory contains host-specific configurations. Each subdirectory corresponds to a machine and includes hardware-specific settings.
*   `modules/`: This directory contains modularized configurations:
    *   `modules/nixos/`: Contains NixOS modules for system-wide configurations. These include `adguard.nix`, `audio.nix`, `base-apps.nix`, `bluetooth.nix`, `boot.nix`, `desktop-apps.nix`, `desktop-env.nix`, `flatpak.nix`, `fonts.nix`, `gc.nix`, `locale.nix`, `network.nix`, `nixvim.nix`, `options.nix`, `ssh.nix`, and `users.nix`.
    *   `modules/nixos/nixvim/`: Contains modules for configuring nixvim. These include `keymaps.nix`, `options.nix`, and `plugins.nix`.
    *   `modules/home/`: Contains home-manager modules for user-specific configurations. These include `git.nix`, `packages.nix`, and `shell.nix`.
*   `config/cosmic/`: This directory holds settings for the Cosmic desktop environment, which are managed outside of the NixOS configuration but are part of the overall setup.

## Development Conventions

*   **Declarative Changes:** All system and user configurations are managed declaratively within `.nix` files. To make changes, you modify these files and then rebuild the system.
*   **Modularity:** New features or configurations should be added as new modules in the `modules/nixos` or `modules/home` directories and then imported into `configuration.nix` or `home.nix` respectively.
*   **Host-Specific Settings:** Any configuration that is unique to a single machine should be placed in the corresponding file within the `hosts/` directory.
*   **User-Specific Settings:** User-level packages and configurations are managed in `home.nix` using `home-manager`.

---

# Projet de Configuration NixOS

## Aperçu du Projet

Ce dépôt contient une configuration NixOS complète et déclarative, gérée à l'aide de Nix Flakes. Elle est conçue pour être reproductible et modulaire, prenant en charge plusieurs machines hôtes (`grospc` et `minipc`). La configuration inclut des paramètres au niveau du système, des environnements spécifiques à l'utilisateur via `home-manager`, et des personnalisations détaillées pour l'environnement de bureau Cosmic.

Le cœur du projet est l'approche modulaire, avec différentes fonctionnalités réparties dans des fichiers séparés sous le répertoire `modules/`. Cela facilite la gestion et l'activation de fonctionnalités telles que l'audio, le Bluetooth, diverses applications et services.

## Compilation et Exécution

Pour appliquer la configuration à un système NixOS, vous devez avoir activé les Nix Flakes. La commande principale pour compiler et basculer vers une nouvelle configuration est :

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Remplacez `<hostname>` par l'hôte cible pour lequel vous souhaitez compiler (par ex., `grospc` ou `minipc`).

**Commandes Courantes :**

*   **Appliquer la configuration :** `sudo nixos-rebuild switch --flake .#<hostname>`
*   **Mettre à jour les entrées du flake :** `nix flake update`
*   **Vérifier le flake :** `nix flake check`

## Structure du Projet

*   `flake.nix` : Le point d'entrée du Nix Flake. Il définit les entrées du projet (comme `nixpkgs` et `home-manager`) et génère les `nixosConfigurations` finales pour chaque hôte.
*   `configuration.nix` : Le fichier de configuration principal à l'échelle du système. Il importe les modules NixOS depuis le répertoire `modules/nixos/`.
*   `home.nix` : Le fichier de configuration principal de `home-manager`. Il importe les modules spécifiques à l'utilisateur depuis le répertoire `modules/home/`.
*   `hosts/` : Ce répertoire contient les configurations spécifiques à chaque hôte. Chaque sous-répertoire correspond à une machine et inclut des paramètres matériels spécifiques.
*   `modules/` : Ce répertoire contient les configurations modularisées :
    *   `modules/nixos/` : Contient les modules NixOS pour les configurations à l'échelle du système. Ceux-ci incluent `adguard.nix`, `audio.nix`, `base-apps.nix`, `bluetooth.nix`, `boot.nix`, `desktop-apps.nix`, `desktop-env.nix`, `flatpak.nix`, `fonts.nix`, `gc.nix`, `locale.nix`, `network.nix`, `nixvim.nix`, `options.nix`, `ssh.nix`, et `users.nix`.
    *   `modules/nixos/nixvim/` : Contient les modules pour la configuration de nixvim. Ceux-ci incluent `keymaps.nix`, `options.nix`, et `plugins.nix`.
    *   `modules/home/` : Contient les modules home-manager pour les configurations spécifiques à l'utilisateur. Ceux-ci incluent `git.nix`, `packages.nix`, et `shell.nix`.
*   `config/cosmic/` : Ce répertoire contient les paramètres pour l'environnement de bureau Cosmic, qui sont gérés en dehors de la configuration NixOS mais font partie de l'installation globale.

## Conventions de Développement

*   **Changements Déclaratifs :** Toutes les configurations système et utilisateur sont gérées de manière déclarative dans des fichiers `.nix`. Pour apporter des modifications, vous modifiez ces fichiers, puis recompilez le système.
*   **Modularité :** Les nouvelles fonctionnalités ou configurations doivent être ajoutées en tant que nouveaux modules dans les répertoires `modules/nixos` ou `modules/home`, puis importées respectivement dans `configuration.nix` ou `home.nix`.
*   **Paramètres Spécifiques à l'Hôte :** Toute configuration unique à une seule machine doit être placée dans le fichier correspondant du répertoire `hosts/`.
*   **Paramètres Spécifiques à l'Utilisateur :** Les paquets et configurations au niveau de l'utilisateur sont gérés dans `home.nix` à l'aide de `home-manager`.