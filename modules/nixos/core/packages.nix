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
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/bigor/nixos";
    };
  };

  environment.systemPackages = with pkgs; [
    # Nix Tooling
    statix
    deadnix

    # Network Utilities
    dig
    wget
    curl

    # Monitoring & Performance
    btop
    htop
    sysstat
    inxi
    pciutils
    usbutils
    mesa-demos
    lm_sensors

    # Archiving
    zip
    unzip

    # Miscellaneous
    fastfetch
  ];
}
