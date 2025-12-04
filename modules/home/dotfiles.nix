{ config, ... }:
let
  dotfilesDir = ../../dotfiles;
in
{
  xdg.configFile = {
    cosmic.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/cosmic";
    "autostart".source = "${dotfilesDir}/autostart";
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/nvim";
  };
}
