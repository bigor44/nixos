{ pkgs, ... }:

{
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    eza
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
    pciutils
    sl
    sysstat
    lm_sensors
  ];
}
