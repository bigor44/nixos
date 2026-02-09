# Home: dotfiles
# Purpose: Manage dotfiles via Home Manager
{
  config,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "cosmic".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/cosmic";
    "autostart".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/autostart";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
  };

}
