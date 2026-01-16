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
  ];
}
