# Home: dotfiles
# Purpose: Links the repo's dotfiles/ into ~/.config
{ config, ... }:
let
  # Absolute path to the live checkout, not a store path: required by mkOutOfStoreSymlink
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    # Writable symlink into the repo: COSMIC saves its settings in place and edits apply without a rebuild
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    # Relative path = copied into the read-only store, so apps (Discord) cannot rewrite their entries
    "autostart".source = ../../dotfiles/autostart;
  };
}
