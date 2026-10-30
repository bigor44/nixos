# Platform: packages
# Purpose: Everyday CLI utilities and hardware/diagnostic tools
{ pkgs, ... }:
{
  # The module (vs. a bare package) also provides a system-wide /etc/tmux.conf
  programs.tmux.enable = true;
  environment.systemPackages = with pkgs; [
    wget
    curl
    htop
    zip
    unzip
    rsync
    fd
    ripgrep
    jq
    dig
    btop
    sysstat
    inxi
    pciutils
    usbutils
    # glxinfo/vulkaninfo: check which GPU driver is actually in use
    mesa-demos
    vulkan-tools
    lm_sensors
    fastfetch
  ];
}
