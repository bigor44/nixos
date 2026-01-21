# Home: default
# Purpose: Entry point for Home Manager configuration
{ osConfig, ... }:
{
  imports = [
    ./shell.nix
    ./apps.nix
    ./dotfiles.nix
    ./packages.nix
  ];

  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    inherit (osConfig.system) stateVersion;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
