# Module: nix/modules.nix
# Purpose: Explicit import list for all custom NixOS and Home Manager modules
{
  # All NixOS modules under the bigor.* namespace
  nixosModules = [
    # Platform - Always-active infrastructure + strategic policies
    # Note: Core Nix settings (caches, flakes, CA trust) are in nix/hosts.nix
    ../modules/nixos/platform/boot.nix
    ../modules/nixos/platform/localization.nix
    ../modules/nixos/platform/network.nix
    ../modules/nixos/platform/packages.nix
    ../modules/nixos/platform/sops.nix
    ../modules/nixos/platform/users.nix
    ../modules/nixos/platform/policies/dns.nix
    ../modules/nixos/platform/policies/storage.nix

    # Capabilities - Optional features and services
    ../modules/nixos/capabilities/audio.nix
    ../modules/nixos/capabilities/blocky.nix
    ../modules/nixos/capabilities/caddy.nix
    ../modules/nixos/capabilities/cpu-power-management.nix
    ../modules/nixos/capabilities/desktop.nix
    ../modules/nixos/capabilities/flatpak.nix
    ../modules/nixos/capabilities/gaming.nix
    ../modules/nixos/capabilities/nfs.nix
    ../modules/nixos/capabilities/sshd.nix
    ../modules/nixos/capabilities/unbound.nix
    ../modules/nixos/capabilities/via.nix
  ];

  # All Home Manager modules under the bigor.home.* namespace
  homeModules = [
    ../modules/home/cli-packages.nix
    ../modules/home/dev-scripts.nix
    ../modules/home/git.nix
    ../modules/home/shell
    ../modules/home/nixvim
    ../modules/home/gui.nix
  ];
}
