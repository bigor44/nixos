{ pkgs, ... }:
{
  # ============================================================================
  # File: modules/nixos/packages/default.nix
  # Description: Core System Packages
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Installs essential command-line tools, system monitoring utilities,
  #          and Nix-related tools available to all users.
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
  ];
}
