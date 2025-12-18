# ============================================================================
# File: /home/bigor/nixos/modules/home/nixvim/plugins/treesitter.nix
# Description: Configures Treesitter and related plugins.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        ensure_installed = [
          "nix"
          "bash"
          "markdown"
          "markdown_inline"
          "json"
          "yaml"
        ];
        highlight.enable = true;
        indent.enable = true;
      };
    };

    # Show code context (function/class) at the top of the window
    treesitter-context = {
      enable = true;
      settings.max_lines = 3;
    };
  };
}
