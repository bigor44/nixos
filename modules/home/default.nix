# Entry point for Home Manager configuration.
# Imports user-specific packages and dotfile modules.
{
  home = {
    username = "bigor";
    homeDirectory = "/home/bigor";
    stateVersion = "25.05";
  };
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./nixvim.nix
  ];
}
