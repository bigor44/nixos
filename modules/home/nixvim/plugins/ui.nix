{
  # ============================================================================
  # File: modules/home/nixvim/plugins/ui.nix
  # Description: UI Components Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures visual enhancements like Gitsigns, Noice, Dressing,
  #          and the Mini suite (statusline, icons).
  # ============================================================================

  programs.nixvim = {
    # Highlights for Mini.notify
    highlight = {
      MiniNotifyNormal = {
        link = "NormalFloat";
      };
      MiniNotifyBorder = {
        link = "FloatBorder";
      };
      MiniNotifyTitle = {
        link = "FloatTitle";
      };
    };

    plugins = {
      web-devicons.enable = true;

      # ========================================================================
      # Git Signs
      # ========================================================================
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
          };
        };
      };

      # ========================================================================
      # Noice (CMD line & Notifications)
      # ========================================================================
      noice = {
        enable = true;
        settings = {
          notify.enabled = true;
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
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

      # ========================================================================
      # Dressing (UI Improvement)
      # ========================================================================
      dressing = {
        enable = true;
        settings = {
          input.enabled = true;
          select = {
            enabled = true;
            backend = [
              "telescope"
              "builtin"
            ];
          };
        };
      };

      # ========================================================================
      # Mini Suite (Statusline, Tabline, Patterns)
      # ========================================================================
      mini = {
        enable = true;
        modules = {
          statusline = { };
          tabline = { };
          hipatterns = {
            highlighters = {
              # Hex color is standard in hipatterns
              hex_color = {
                __raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
              };
              fixme = {
                pattern = "%f[%w]()FIXME()%f[%W]";
                group = "MiniHipatternsFixme";
              };
              hack = {
                pattern = "%f[%w]()HACK()%f[%W]";
                group = "MiniHipatternsHack";
              };
              todo = {
                pattern = "%f[%w]()TODO()%f[%W]";
                group = "MiniHipatternsTodo";
              };
              note = {
                pattern = "%f[%w]()NOTE()%f[%W]";
                group = "MiniHipatternsNote";
              };
            };
          };
        };
      };
    };
  };
}
