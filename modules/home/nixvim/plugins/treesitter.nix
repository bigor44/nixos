_: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
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
