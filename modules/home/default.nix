{ lib, osConfig, ... }:
{
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
  ]
  ++ lib.optional (osConfig.services.desktopManager.gnome.enable or false) ./theme.nix;
}
