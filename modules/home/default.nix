# Home: configuration
# Purpose: Main Home Manager configuration
{ osConfig, ... }:
{
  imports = [
    ./git.nix
    ./dotfiles.nix
  ];

  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    inherit (osConfig.system) stateVersion;
  };
}
