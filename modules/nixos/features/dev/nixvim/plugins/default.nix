# Feature: nixvim-plugins
# Purpose: Entry point for nixvim plugins configuration
{
  imports = [
    ./completion.nix
    ./editing.nix
    ./lsp.nix
    ./mini.nix
    ./navigation.nix
    ./ui.nix
  ];
}
