{ config, ... }:
{
  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "./dotfile/nvim";
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "./dotfiles/cosmic";
    "autostart".source = config.lib.file.mkOutOfStoreSymlink "./dotfiles/autostart";
  };
}
