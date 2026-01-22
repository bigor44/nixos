# Feature: nixvim-editor
# Purpose: Editor-related plugins for nixvim (Telescope, Neo-tree, etc.)
{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
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

    lazygit.enable = true;
    undotree.enable = true;
    trouble.enable = true;

    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          json = [ "prettier" ];
          jsonc = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          toml = [ "taplo" ];
        };
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
      };
    };
  };
}
