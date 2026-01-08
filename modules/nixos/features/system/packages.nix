# Feature: system.packages
# Purpose: Essential CLI tools and Nix helper
{ pkgs, ... }:
{
  programs = {
    zsh.enable = true;
    tmux.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/bigor/nixos";
    };
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
