# Platform: system.packages
# Purpose: Essential CLI tools and Nix helper
{ pkgs, ... }:
{
  programs = {
    zsh.enable = true;
    tmux.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    htop
    zip
    unzip
    sops
    age
    ssh-to-age

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
