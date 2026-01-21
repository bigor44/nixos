# Feature: nixvim-plugins
# Purpose: Plugin imports aggregator for nixvim
{
  imports = [
    ./editor.nix
    ./treesitter.nix
    ./lsp.nix
    ./ui.nix
    ./mini.nix
    ./cmp.nix
  ];
}
