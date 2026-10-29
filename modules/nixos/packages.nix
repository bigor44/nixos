# Platform: packages
# Purpose: Essential CLI tools
{ pkgs, ... }:
{
  programs.tmux.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    htop
    zip
    unzip
    rsync

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
