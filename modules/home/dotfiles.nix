{ config, ... }:
let
  nixosConfigPath = "/home/bigor/nixos";
  dotfilesPath = "${nixosConfigPath}/modules/home/dotfiles";
in
{
  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    "autostart".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/autostart";
  };
}
