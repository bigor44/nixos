{ pkgs, ... }:
{
  programs = {
    fish.enable = true; # Modern shell with autosuggestions
    tmux.enable = true; # Terminal multiplexer
    nh = {
      enable = true; # Nix Helper for simplified system management
      clean.enable = true; # Automated garbage collection
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/bigor/nixos";
    };
  };

  # System-wide packages available to all users
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
    fastfetch # System information fetcher
  ];
}
