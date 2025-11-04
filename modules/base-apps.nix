{ pkgs, ... }:
{
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    bat
    dig
    btop
    wget
    curl
    fastfetch
    tree
    zip
    unzip
    htop
    ripgrep
    pciutils
    sl
    sysstat
    lm_sensors
  ];
}
