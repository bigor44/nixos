{
  programs.nixvim = {
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

      noice = {
        enable = true;
        settings = {
          notify.enabled = false;
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

      mini = {
        enable = true;
        modules = {
          statusline = {};
          tabline = {};
          # icons = {}; # Disabled to avoid conflict with web-devicons
          notify = {
            window = {
              config = {
                border = "double";
              };
              winblend = 0;
            };
          };
          # Hipatterns needs special handling for hex_color/custom patterns which are functions/tables
          hipatterns = {
            highlighters = {
              # Hex color is standard in hipatterns, we might need __raw if the module doesn't expose it easily
              # But NixVim's mini module often simplifies this. Let's check docs or use __raw for safety.
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
