# Flake: modules
# Purpose: Explicit import list for all custom NixOS and Home Manager modules
{
  # All NixOS modules under the bigor.* namespace
  nixosModules = [
    # Platform - Always-active infrastructure + strategic policies
    ../modules/nixos/platform/nix-settings.nix
    ../modules/nixos/platform/boot.nix
    ../modules/nixos/platform/fonts.nix
    ../modules/nixos/platform/localization.nix
    ../modules/nixos/platform/network.nix
    ../modules/nixos/platform/packages.nix
    ../modules/nixos/platform/sops.nix
    ../modules/nixos/platform/firewall.nix
    ../modules/nixos/platform/users.nix
    ../modules/nixos/platform/policies/dns.nix
    ../modules/nixos/platform/policies/storage.nix

    # Features - Optional features and services
    ../modules/nixos/features/audio.nix
    ../modules/nixos/features/blocky.nix
    ../modules/nixos/features/bluetooth.nix
    ../modules/nixos/features/caddy.nix
    ../modules/nixos/features/cpu-power-management.nix
    ../modules/nixos/features/desktop.nix
    ../modules/nixos/features/flatpak.nix
    ../modules/nixos/features/gaming.nix
    ../modules/nixos/features/gatus.nix
    ../modules/nixos/features/nfs-client.nix
    ../modules/nixos/features/nfs-server.nix
    ../modules/nixos/features/sshd.nix
    ../modules/nixos/features/unbound.nix

    ../modules/nixos/features/keyboardVIA.nix
  ];

  # All Home Manager modules under the bigor.home.* namespace
  homeModules = [
    # Always active (like platform modules)
    ../modules/home/shell
    ../modules/home/git.nix
    ../modules/home/cli-tools.nix

    # Optional features
    ../modules/home/nixvim
    ../modules/home/dev-tools.nix
    ../modules/home/dev-scripts.nix
    ../modules/home/gui.nix
    ../modules/home/wallpapers.nix
  ];
}
