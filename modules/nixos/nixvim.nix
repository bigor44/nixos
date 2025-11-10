/*
  Title: Neovim Configuration
  Description: Configures Neovim by importing modularized settings.
*/
{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Import modularized configuration
    imports = [
      ./nixvim/options.nix
      ./nixvim/plugins.nix
    ];

    keymaps = import ./nixvim/keymaps.nix;
  };
}
