# Entry point for Home Manager configuration.
# This module defines the user environment for 'bigor', including
# shell configuration, GUI applications, and dotfiles management.
{...}: {
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    stateVersion = "25.05";
  };
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./dotfiles.nix
  ];
}
