# Flake: modules
# Purpose: Explicit import list for all custom NixOS modules
{
  # All NixOS modules under the bigor.* namespace
  nixosModules = [
    # Platform - Core System
    ../modules/nixos/platform/core.nix
    ../modules/nixos/platform/packages.nix
    ../modules/nixos/platform/users.nix
    ../modules/nixos/platform/locale.nix
    ../modules/nixos/platform/firewall.nix
    ./home-manager.nix

    # Features - Graphics
    ../modules/nixos/features/graphics/desktop.nix
    ../modules/nixos/features/graphics/flatpak.nix
    ../modules/nixos/features/graphics/gaming.nix

    # Features - Hardware
    ../modules/nixos/features/hardware/audio.nix
    ../modules/nixos/features/hardware/bluetooth.nix
    ../modules/nixos/features/hardware/cpu-power-management.nix
    ../modules/nixos/features/hardware/keyboardVIA.nix

    # Features - Dev
    ../modules/nixos/features/dev/tools.nix
  ];
}
