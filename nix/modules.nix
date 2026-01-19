# Flake: modules
# Purpose: Explicit import list for all custom NixOS and Home Manager modules
{
  # All NixOS modules under the bigor.* namespace
  nixosModules = [
    # Platform - Core System
    ../modules/nixos/platform/boot.nix
    ../modules/nixos/platform/shell.nix
    ../modules/nixos/platform/nix-core.nix
    ../modules/nixos/platform/packages.nix
    ../modules/nixos/platform/sops.nix
    ../modules/nixos/platform/users.nix
    ../modules/nixos/platform/localization.nix
    ../modules/nixos/platform/fonts.nix

    # Platform - Networking
    ../modules/nixos/platform/network.nix
    ../modules/nixos/platform/firewall.nix

    # Platform - DNS
    ../modules/nixos/platform/dns

    # Platform - Policies
    ../modules/nixos/platform/policies/storage.nix

    # Features
    ../modules/nixos/features/audio.nix
    ../modules/nixos/features/bluetooth.nix
    ../modules/nixos/features/caddy.nix
    ../modules/nixos/features/cpu-power-management.nix
    ../modules/nixos/features/desktop.nix
    ../modules/nixos/features/flatpak.nix
    ../modules/nixos/features/gaming.nix
    ../modules/nixos/features/gatus.nix
    ../modules/nixos/features/keyboardVIA.nix
    ../modules/nixos/features/nfs-client.nix
    ../modules/nixos/features/nfs-server.nix
    ../modules/nixos/features/sshd.nix
    ../modules/nixos/features/nixvim
    ../modules/nixos/features/desktop-apps.nix
    ../modules/nixos/features/git.nix
    ../modules/nixos/features/dev-tools.nix
    ../modules/nixos/features/dev-scripts.nix
  ];

  # All Home Manager modules under the bigor.home.* namespace
  homeModules = [ ];
}
