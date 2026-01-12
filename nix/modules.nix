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

    # Features - Desktop & Hardware
    ../modules/nixos/features/desktop.nix
    ../modules/nixos/features/audio.nix
    ../modules/nixos/features/gaming.nix
    ../modules/nixos/features/flatpak.nix
    ../modules/nixos/features/via.nix

    # Policies (strategic decisions)
    ../modules/nixos/policies/kernel.nix
    ../modules/nixos/policies/power.nix
    ../modules/nixos/policies/dns.nix
    ../modules/nixos/policies/storage.nix

    # Services
    ../modules/nixos/services/blocky.nix
    ../modules/nixos/services/caddy.nix
    ../modules/nixos/services/nfs.nix
    ../modules/nixos/services/sshd.nix
    ../modules/nixos/services/unbound.nix

    # Profiles (composite configurations)
    ../modules/nixos/profiles/workstation.nix
    ../modules/nixos/profiles/homelab-master.nix
  ];

  # All Home Manager modules under the bigor.home.* namespace
  homeModules = [
    ../modules/home/features/cli-packages.nix
    ../modules/home/features/dev-scripts.nix
    ../modules/home/features/git.nix
    ../modules/home/features/shell
    ../modules/home/features/nixvim
    ../modules/home/features/gui.nix
  ];
}
