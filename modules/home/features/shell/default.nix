# Module: features.shell
# Purpose: Zsh shell with Starship prompt, fzf, zoxide, and bat
{
  lib,
  ...
}:
with lib;
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./tools.nix
  ];

  options.bigor.home.features.shell.enable = mkEnableOption "Shell configuration";
}
