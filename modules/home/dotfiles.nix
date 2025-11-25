{ config, ... }:
let
  repoPath = "${config.home.homeDirectory}/nixos";
  dotfilesPath = "${repoPath}/modules/home/dotfiles";
in
{
  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    "autostart".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/autostart";
  };
}
