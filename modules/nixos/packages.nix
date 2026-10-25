# Platform: packages
# Purpose: Essential CLI tools and Nix helper
{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
    tmux.enable = true;
    nh = {
      enable = true;
      flake = "/home/bigor/nixos";
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 7d --keep 5";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    htop
    zip
    unzip

    # Modern CLI tools
    fd
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
    vulkan-tools
    amdgpu_top
    lm_sensors
    fastfetch
  ];
}
