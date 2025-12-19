# ============================================================================
# File: modules/home/nixvim/plugins/default.nix
# Description: Main entry point for NixVim plugins.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
_: {
  imports = [
    ./ai.nix
    ./editor.nix
    ./treesitter.nix
    ./lsp.nix
    ./ui.nix
    ./utils.nix
    ./cmp.nix
  ];
}
