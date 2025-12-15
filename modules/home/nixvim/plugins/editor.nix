{
  # ============================================================================
  # File: modules/home/nixvim/plugins/editor.nix
  # Description: Editor Plugins Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures plugins that enhance the core editing experience, such as
  #          file navigation (Telescope, Neo-tree) and Git integration (LazyGit).
  # ============================================================================

  programs.nixvim.plugins = {
    # ==========================================================================
    # Telescope (Fuzzy Finder)
    # ==========================================================================
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
          file_ignore_patterns = [
            "^.git/"
            "^node_modules/"
          ];
          layout_config.horizontal.prompt_position = "top";
          sorting_strategy = "ascending";
        };
      };
    };

    # ==========================================================================
    # Neo-tree (File Explorer)
    # ==========================================================================
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
            { source = "filesystem"; }
            { source = "buffers"; }
            { source = "git_status"; }
          ];
        };
      };
    };

    # ==========================================================================
    # Git Integration
    # ==========================================================================
    lazygit.enable = true;
  };
}
