{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          cmp = true;
          treesitter = true;
          gitsigns = true;
          snacks = true;
          noice = true;
          mini = {
            enabled = true;
            indentscope_color = "";
          };
        };
      };
    };

    plugins = {
      # --- Mini.nvim Suite ---
      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          # UI
          statusline = { };
          tabline = { };
          cursorword = { };
          indentscope = { };
          icons = { };

          # Editing
          pairs = { };
          surround = { };
          comment = { };

          # Utilities
          trailspace = { };
        };
      };

      # --- Git ---
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add = {
              text = "│";
            };
            change = {
              text = "│";
            };
            delete = {
              text = "_";
            };
          };
        };
      };

      # --- UI Enhancements ---
      noice = {
        enable = true;
        settings = {
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
            inc_rename = false;
            lsp_doc_border = false;
          };
        };
      };

      notify = {
        enable = true;
        settings = {
          background_colour = "#000000";
        };
      };

      dressing = {
        enable = true;
        settings = {
          input = {
            enabled = true;
          };
          select = {
            enabled = true;
            backend = [
              "telescope"
              "builtin"
            ];
          };
        };
      };

      # --- Utilities ---
      colorizer = {
        enable = true;
        settings = {
          userDefaultOptions = {
            names = false;
            RGB = true;
            RRGGBB = true;
          };
        };
      };

      which-key.enable = true;
    };
  };
}
