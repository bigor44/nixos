# Platform: packages
# Purpose: Essential CLI tools and Nix helper
{ pkgs, ... }:
{
  programs = {
    zsh.enable = true;
    tmux.enable = true;
    nh = {
      enable = true;
      flake = "/home/bigor/nixos";
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    htop
    zip
    unzip

    # Modern CLI tools
    eza
    fd
    findutils
    ripgrep
    jq

    # Network utilities
    dig

    # Monitoring & performance
    btop
    sysstat
    inxi
    pciutils
    usbutils
    mesa-demos
    lm_sensors
    fastfetch
  ];
}
