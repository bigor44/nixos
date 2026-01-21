# Home: dotfiles
# Purpose: Manage dotfiles via Home Manager
{
  config,
  lib,
  osConfig,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  config = lib.mkIf (osConfig.bigor.features.graphics.desktop.enable or false) {
    xdg.configFile = {
      "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
      "autostart".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/autostart";
    };
  };
}
