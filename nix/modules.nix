# Module: nix/modules.nix
# Purpose: Explicit import list for all custom NixOS and Home Manager modules
{
  # All NixOS modules under the bigor.* namespace
  nixosModules = [
    # Features - System
    ../modules/nixos/features/system/base
    ../modules/nixos/features/system/boot
    ../modules/nixos/features/system/french-locale
    ../modules/nixos/features/system/network
    ../modules/nixos/features/system/packages
    ../modules/nixos/features/system/sops
    ../modules/nixos/features/system/users

    # Features - Desktop
    ../modules/nixos/features/desktop/base
    ../modules/nixos/features/desktop/cosmic
    ../modules/nixos/features/desktop/apps
    ../modules/nixos/features/desktop/tuning

    # Features - Hardware/Peripherals
    ../modules/nixos/features/audio
    ../modules/nixos/features/bluetooth
    ../modules/nixos/features/fonts
    ../modules/nixos/features/gaming
    ../modules/nixos/features/flatpak

    # Services
    ../modules/nixos/services/blocky
    ../modules/nixos/services/caddy
    ../modules/nixos/services/nfs
    ../modules/nixos/services/sshd
    ../modules/nixos/services/unbound

    # Profiles (composite configurations)
    ../modules/nixos/profiles/workstation
    ../modules/nixos/profiles/homelab_master
  ];

  # All Home Manager modules under the bigor.home.* namespace
  homeModules = [
    ../modules/home/cli-packages
    ../modules/home/git
    ../modules/home/shell
    ../modules/home/nixvim
    ../modules/home/features/gui
  ];
}
