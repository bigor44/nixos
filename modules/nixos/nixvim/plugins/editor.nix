{
  # ============================================================================
  # Editor Plugins
  # ============================================================================
  # Plugins that enhance the core editing experience:
  # - Telescope (Fuzzy finder)
  # - Neo-tree (File explorer)
  # - LazyGit (Git interface)
  # ============================================================================
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Find buffers";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "Help tags";
        };
      };
      settings = {
        defaults = {
          file_ignore_patterns = ["^.git/" "^node_modules/"];
          layout_config.horizontal.prompt_position = "top";
          sorting_strategy = "ascending";
        };
      };
    };

    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        filesystem = {
          bind_to_cwd = false;
          follow_current_file.enabled = true;
        };
        source_selector = {
          winbar = true;
          sources = [
            {source = "filesystem";}
            {source = "buffers";}
            {source = "git_status";}
          ];
        };
      };
    };

    lazygit.enable = true;
  };
}
