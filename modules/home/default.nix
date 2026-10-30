# Home: default
# Purpose: Home Manager entry point for bigor; aggregates the user-level modules
# osConfig: the evaluated NixOS config, passed in by the Home Manager NixOS module
{ osConfig, ... }:
{
  imports = [
    ./git.nix
    ./dotfiles.nix
  ];
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    # Follow the system release so the two never drift apart
    inherit (osConfig.system) stateVersion;
  };
}
