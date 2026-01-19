# Module: cli-tools
# Purpose: Essential CLI tools for all hosts
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Modern CLI tools
    eza
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
    lm_sensors
    fastfetch
  ];
}
