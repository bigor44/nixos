# Platform: system.packages
# Purpose: Essential CLI tools and Nix helper
{ pkgs, inputs, ... }:
{
  programs = {
    zsh.enable = true;
    tmux.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = toString inputs.self;
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
