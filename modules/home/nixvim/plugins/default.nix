# Home: nixvim-plugins
# Purpose: Plugin imports aggregator for nixvim
_: {
  imports = [
    ./editor.nix
    ./treesitter.nix
    ./lsp.nix
    ./ui.nix
    ./utils.nix
    ./cmp.nix
  ];
}
