{
  programs.nixvim.plugins = {
    # --- Treesitter ---
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings.highlight.enable = true;
      settings.indent.enable = true;
    };
    treesitter-context = {
      enable = true;
      settings.max_lines = 3;
    };

    # --- File Explorer ---
    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        window.width = 30;
      };
    };

    # --- Fuzzy Finder (Telescope) ---
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
        ui-select.enable = true;
      };
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fh" = "help_tags";
      };
    };

    # --- Navigation ---
    navbuddy = {
      enable = true;
      settings.lsp.auto_attach = true;
    };

    trouble = {
      enable = true;
      settings = {
        auto_open = false;
        auto_close = true;
      };
    };

    persistence.enable = true;
  };
}
