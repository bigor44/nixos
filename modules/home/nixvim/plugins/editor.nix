{
  programs.nixvim = {
    plugins = {
      # --- Telescope (Fuzzy Finder) ---
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
            layout_config = {
              horizontal = {
                prompt_position = "top";
              };
            };
            sorting_strategy = "ascending";
          };
        };
      };

      # --- Neo-tree (File Explorer) ---
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        sources = [
          "filesystem"
          "buffers"
          "git_status"
        ];
        filesystem = {
          bindToCwd = false;
          followCurrentFile = {
            enabled = true;
          };
        };
      };

      # --- Todo Comments ---
      todo-comments = {
        enable = true;
        settings = {
          signs = true;
        };
      };

      # --- Git Integration ---
      lazygit = {
        enable = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle Explorer";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options.desc = "LazyGit";
      }
    ];
  };
}
