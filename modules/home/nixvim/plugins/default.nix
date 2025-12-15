{
  # ============================================================================
  # File: modules/home/nixvim/plugins/default.nix
  # Description: Neovim Plugins Import
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Aggregates all plugin configurations into a single module.
  # ============================================================================

  imports = [
    ./editor.nix
    ./treesitter.nix
    ./lsp.nix
    ./ui.nix
    ./utils.nix
  ];
}
