{
  # ============================================================================
  # File: modules/home/nixvim/plugins/treesitter.nix
  # Description: Treesitter Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures advanced syntax highlighting and parsing.
  #          Includes 'treesitter-context' to show current scope context.
  # ============================================================================

  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        ensure_installed = [
          "lua"
          "nix"
          "bash"
          "markdown"
          "markdown_inline"
          "json"
          "yaml"
          "python"
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
