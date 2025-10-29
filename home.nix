{ config, pkgs, ... }:

{
  home.username = "bigor";
  home.homeDirectory = "/home/bigor";
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    ripgrep
    nil
    nixpkgs-fmt
    gcc
    nixfmt-rfc-style
  ];
  imports = [
    ./home/git.nix
    ./home/zsh.nix
  ];
}


