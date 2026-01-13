# Module: shell
# Purpose: Zsh shell with Starship prompt, fzf, zoxide, and bat
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./tools.nix
  ];
}
