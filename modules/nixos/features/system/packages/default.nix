{ pkgs, ... }:
{
  # ============================================================================
  # File: modules/nixos/features/system/packages/default.nix
  # Description: Installs essential command-line tools and system utilities.
  # Author: Bigor
  # Date: 2025-12-18
  # ============================================================================

  programs = {
    fish.enable = true;
    tmux.enable = true;

    # Nix Helper (nh) Configuration
    nh = {
      enable = true;
      clean.enable = true;
      # Garbage collection policy:
      # - Keep the last 3 generations
      # - Keep any generation created in the last 4 days
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/bigor/nixos";
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    htop
    zip
    unzip
    ssh-to-age
    age
    sops
  ];
}
