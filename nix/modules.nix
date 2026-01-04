# Module: nix/modules.nix
# Purpose: Explicit import list for all custom NixOS and Home Manager modules
{
  # All NixOS modules under the bigor.* namespace
  nixosModules = [
    # Features - System
    ../modules/nixos/features/system/base.nix
    ../modules/nixos/features/system/boot.nix
    ../modules/nixos/features/system/french-locale.nix
    ../modules/nixos/features/system/network.nix
    ../modules/nixos/features/system/packages.nix
    ../modules/nixos/features/system/sops.nix
    ../modules/nixos/features/system/users.nix

    # Features - Desktop
    ../modules/nixos/features/desktop/base.nix
    ../modules/nixos/features/desktop/cosmic.nix
    ../modules/nixos/features/desktop/apps.nix
    ../modules/nixos/features/desktop/tuning.nix

    # Features - Hardware/Peripherals
    ../modules/nixos/features/audio.nix
    ../modules/nixos/features/bluetooth.nix
    ../modules/nixos/features/fonts.nix
    ../modules/nixos/features/gaming.nix
    ../modules/nixos/features/flatpak.nix

    # Services
    ../modules/nixos/services/blocky.nix
    ../modules/nixos/services/caddy.nix
    ../modules/nixos/services/nfs.nix
    ../modules/nixos/services/sshd.nix
    ../modules/nixos/services/unbound.nix

    # Profiles (composite configurations)
    ../modules/nixos/profiles/workstation.nix
    ../modules/nixos/profiles/homelab_master.nix
  ];

  # All Home Manager modules under the bigor.home.* namespace
  homeModules = [
    ../modules/home/cli-packages.nix
    ../modules/home/git.nix
    ../modules/home/shell.nix
    ../modules/home/nixvim
    ../modules/home/features/gui.nix
  ];
}
