{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          cmp = true;
          treesitter = true;
          native_lsp = {
            enabled = true;
          };
          mini = {
            enabled = true;
          };
          noice = true;
        };
      };
    };

    plugins = {
      # --- Snacks ---
      snacks = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          quickfile.enabled = true;

          dashboard.enabled = false; # Replaced by mini.starter

          notifier.enabled = true;
          statuscolumn.enabled = true;
          bufdelete.enabled = false; # Replaced by mini.bufremove
          terminal.enabled = true;
          lazygit.enabled = true;
        };
      };

      # --- Noice ---
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
          };
          notify = {
            enabled = false;
            view = "notify";
          };
        };
      };

      # --- Mini.nvim ---
      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          icons = { };
          ai = { };
          tabline = { };
          trailspace = { };
          bufremove = { };
          starter = { };
          files = {
            windows = {
              preview = true;
              width_focus = 30;
              width_preview = 50;
            };
            options = {
              use_as_default_explorer = true;
            };
          };
          pick = {
            window = {
              config = {
                __raw = "''\n                  function()
                    local height = math.floor(0.618 * vim.o.lines)
                    local width = math.floor(0.618 * vim.o.columns)
                    return {
                      anchor = \"NW\",
                      height = height,
                      width = width,
                      row = math.floor(0.5 * (vim.o.lines - height)),
                      col = math.floor(0.5 * (vim.o.columns - width)),
                      border = \"rounded\",
                    }
                  end
                ''";
              };
            };
          };
          diff = {
            view = {
              style = "sign";
              signs = {
                add = "│";
                change = "│";
                delete = "_";
              };
            };
            source = {
              __raw = "''require(\"mini.diff\").gen_source.git()''";
            };
            delay = {
              text_change = 200;
            };
          };
          hipatterns = {
            highlighters = {
              hex_color = {
                __raw = "''require(\"mini.hipatterns\").gen_highlighter.hex_color()''";
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
              warning = {
                pattern = "%f[%w]()WARNING()%f[%W]";
                group = "DiagnosticWarn";
              };
            };
          };
          pairs = { };
          comment = { };
          surround = { };
          cursorword = {
            delay = 200;
          };
          indentscope = {
            symbol = "│";
            options = {
              try_as_border = true;
            };
            draw = {
              delay = 100;
              animation = {
                __raw = "''require(\"mini.indentscope\").gen_animation.none()''";
              };
            };
          };
          statusline = {
            use_icons = true;
            set_vim_settings = false;
          };
          clue = {
            triggers = [
              {
                mode = "n";
                keys = "<Leader>";
              }
              {
                mode = "x";
                keys = "<Leader>";
              }
              {
                mode = "n";
                keys = "g";
              }
              {
                mode = "x";
                keys = "g";
              }
              {
                mode = "n";
                keys = "'";
              }
              {
                mode = "n";
                keys = "`";
              }
              {
                mode = "n";
                keys = "\"";
              }
              {
                mode = "x";
                keys = "\"";
              }
              {
                mode = "i";
                keys = "<C-r>";
              }
              {
                mode = "c";
                keys = "<C-r>";
              }
              {
                mode = "n";
                keys = "<C-w>";
              }
              {
                mode = "n";
                keys = "z";
              }
              {
                mode = "x";
                keys = "z";
              }
              {
                mode = "n";
                keys = "[";
              }
              {
                mode = "n";
                keys = "]";
              }
            ];
            clues = [
              { __raw = "require('mini.clue').gen_clues.builtin_completion()"; }
              { __raw = "require('mini.clue').gen_clues.g()"; }
              { __raw = "require('mini.clue').gen_clues.marks()"; }
              { __raw = "require('mini.clue').gen_clues.registers()"; }
              { __raw = "require('mini.clue').gen_clues.windows()"; }
              { __raw = "require('mini.clue').gen_clues.z()"; }
              {
                mode = "n";
                keys = "<leader>f";
                desc = "+Find";
              }
              {
                mode = "n";
                keys = "<leader>c";
                desc = "+Code";
              }
              {
                mode = "n";
                keys = "<leader>d";
                desc = "+Debug";
              }
              {
                mode = "n";
                keys = "<leader>x";
                desc = "+Diagnostics";
              }
              {
                mode = "n";
                keys = "<leader>b";
                desc = "+Buffer";
              }
              {
                mode = "n";
                keys = "<leader>g";
                desc = "+Git";
              }
              {
                mode = "n";
                keys = "[";
                desc = "+Previous";
              }
              {
                mode = "n";
                keys = "]";
                desc = "+Next";
              }
            ];
            window = {
              delay = 300;
              config = {
                width = "auto";
                border = "rounded";
              };
            };
          };
        };
      };
    };
  };
}
