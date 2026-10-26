# Home: dotfiles
# Purpose: Manage dotfiles via Home Manager
{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  # Out-of-store symlinks stay writable (COSMIC saves its settings there) and edits apply without a rebuild
  xdg.configFile = {
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    # Copied into the store (read-only): Discord rewrites its autostart entry with a store path on every launch
    "autostart".source = ../../dotfiles/autostart;
  };
}
