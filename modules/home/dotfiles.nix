{ config, ... }:
let
  # Ajustez ce chemin selon l'endroit où vous clonez votre repo sur le disque
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    "autostart".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/autostart";
  };
}
