{pkgs, ...}: {
  # ============================================================================
  # System Packages
  # ============================================================================
  # Installs essential command-line tools and utilities available to all users.
  # Includes:
  # - Nix tooling (statix, deadnix, nh)
  # - Network utilities (dig, wget, curl)
  # - System monitoring (btop, htop, inxi)
  # ============================================================================
  programs = {
    fish.enable = true;
    tmux.enable = true;
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
