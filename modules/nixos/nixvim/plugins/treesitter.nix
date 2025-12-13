{
  # ============================================================================
  # Treesitter
  # ============================================================================
  # Advanced syntax highlighting and parsing.
  # Includes 'treesitter-context' to show the current function/scope at the top.
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
    treesitter-context = {
      enable = true;
      settings.max_lines = 3;
    };
  };
}
