# Feature: nixvim-plugins
# Purpose: Entry point for nixvim plugins configuration
{
  imports = [
    ./completion.nix
    ./editor.nix
    ./lsp.nix
    ./mini.nix
    ./treesitter.nix
    ./ui.nix
  ];
}
