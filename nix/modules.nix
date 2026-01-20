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
    ../modules/nixos/platform/network/default.nix
    ../modules/nixos/platform/network/firewall.nix

    # Platform - DNS
    ../modules/nixos/platform/dns

    # Platform - Policies
    ../modules/nixos/platform/policies/storage.nix

    # Features - Graphics
    ../modules/nixos/features/graphics/desktop.nix
    ../modules/nixos/features/graphics/apps.nix
    ../modules/nixos/features/graphics/flatpak.nix
    ../modules/nixos/features/graphics/gaming.nix

    # Features - Hardware
    ../modules/nixos/features/hardware/audio.nix
    ../modules/nixos/features/hardware/bluetooth.nix
    ../modules/nixos/features/hardware/cpu-power-management.nix
    ../modules/nixos/features/hardware/keyboardVIA.nix

    # Features - Services
    ../modules/nixos/features/services/caddy.nix
    ../modules/nixos/features/services/gatus.nix
    ../modules/nixos/features/services/nfs-client.nix
    ../modules/nixos/features/services/nfs-server.nix
    ../modules/nixos/features/services/sshd.nix

    # Features - Dev
    ../modules/nixos/features/dev/git.nix
    ../modules/nixos/features/dev/nixvim
    ../modules/nixos/features/dev/tools.nix
    ../modules/nixos/features/dev/scripts.nix
  ];

  # All Home Manager modules under the bigor.home.* namespace
  homeModules = [ ];
}
