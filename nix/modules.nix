# Module: nix/modules.nix
# Purpose: Explicit import list for all custom NixOS and Home Manager modules
{
  # All NixOS modules under the bigor.* namespace
  nixosModules = [
    # Common - Non-optional base configuration (applied to all hosts)
    # Note: Core Nix settings (caches, flakes, CA trust) are in nix/hosts.nix
    ../modules/nixos/common/boot.nix
    ../modules/nixos/common/network.nix
    ../modules/nixos/common/packages.nix
    ../modules/nixos/common/sops.nix
    ../modules/nixos/common/users.nix

    # Features - Optional capabilities
    ../modules/nixos/features/french-locale.nix
    ../modules/nixos/features/desktop.nix
    ../modules/nixos/features/audio.nix
    ../modules/nixos/features/gaming.nix
    ../modules/nixos/features/flatpak.nix
    ../modules/nixos/features/via.nix
    ../modules/nixos/features/hardware/cpu-power-management.nix

    # Policies (strategic decisions)
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
