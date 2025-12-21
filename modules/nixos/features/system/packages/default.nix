# Feature: system.packages
# Purpose: Essential CLI tools and Nix helper
{ pkgs, ... }:
{
  programs = {
    fish.enable = true;
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
    ssh-to-age
    age
    sops
  ];
}
