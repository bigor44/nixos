{
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
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
          };
        };
      };
    };
    treesitter-context = {
      enable = true;
      settings.max_lines = 3;
    };
  };
}
