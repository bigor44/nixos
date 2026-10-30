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
    fd
    ripgrep
    jq
    dig
    btop
    sysstat
    inxi
    pciutils
    usbutils
    mesa-demos
    vulkan-tools
    lm_sensors
    fastfetch
  ];
}
