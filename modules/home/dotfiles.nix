{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    "autostart".source = ../../dotfiles/autostart;
  };
}
