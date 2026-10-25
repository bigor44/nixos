# Home: dotfiles
# Purpose: Manage dotfiles via Home Manager
{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    # Copied into the store (read-only): Discord rewrites its autostart entry with a store path on every launch
    "autostart".source = ../../dotfiles/autostart;
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
  };
}
