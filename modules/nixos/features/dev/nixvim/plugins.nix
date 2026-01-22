# Feature: nixvim-plugins
# Purpose: Consolidated plugin configuration for nixvim
{ inputs, pkgs, ... }:
let
  # Use toString inputs.self to get the flake path dynamically
  flakePath = toString inputs.self;
in
{
  programs.nixvim.plugins = {
    # ==========================================================================
    # Completion (CMP)
    # ==========================================================================
    cmp = {
      enable = true;
      settings = {
        snippet.expand = "function(args) vim.fn[\"vsnip#anonymous\"](args.body) end";

        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<Up>" = "cmp.mapping.select_prev_item()";
        };

        sources = [
          { name = "nvim_lsp"; }
          { name = "vsnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };
    vsnip.enable = true;

    # ==========================================================================
    # Editor & Utils
    # ==========================================================================
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

    # ==========================================================================
    # LSP
    # ==========================================================================
    lsp = {
      enable = true;

      servers = {
        bashls.enable = true;
        marksman.enable = true;

        jsonls = {
          enable = true;
          settings.json = {
            validate.enable = true;
            schemas = [
              {
                fileMatch = [ "package.json" ];
                url = "https://json.schemastore.org/package.json";
              }
            ];
          };
        };

        yamlls = {
          enable = true;
          settings.yaml = {
            keyOrdering = false;
            validate = true;
            schemaStore.enable = true;
          };
        };

        nixd = {
          enable = true;
          settings = {
            nixd = {
              nixpkgs.expr = ''
                let
                  flake = builtins.getFlake "${flakePath}";
                in
                  import flake.inputs.nixpkgs { system = \"x86_64-linux\"; }
              '';

              formatting.command = [ "nixfmt" ];

              options = {
                nixos.expr = ''
                  let
                    flake = builtins.getFlake "${flakePath}";
                  in
                    builtins.mapAttrs (_: cfg: cfg.options) flake.nixosConfigurations
                '';

                home-manager.expr = ''
                  let
                    flake = builtins.getFlake "${flakePath}";
                    hostConfig = builtins.head (builtins.attrValues flake.nixosConfigurations);
                  in
                    hostConfig.options.home-manager.users.type.getSubOptions []
                '';
              };

              diagnostics = {
                enable = true;
                excluded = [ "unused-binding" ];
              };
            };
          };
        };
      };

      keymaps = {
        lspBuf = {
          gd = "definition";
          gD = "declaration";
          gr = "references";
          gi = "implementation";
          K = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
          "<leader>f" = "format";
        };
      };
    };

    # ==========================================================================
    # Mini.nvim
    # ==========================================================================
    mini = {
      enable = true;
      modules = {
        ai = { };
        cursorword = { };
        indentscope = { };
        pairs = { };
        surround = { };
        comment = { };
        trailspace = { };
        statusline = { };
        tabline = { };

        hipatterns = {
          highlighters = {
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
              mode = "i";
              keys = "<C-x>";
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
              mode = "x";
              keys = "'";
            }
            {
              mode = "x";
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
          ];
          clues = [
            { __raw = "require('mini.clue').gen_clues.builtin_completion()"; }
            { __raw = "require('mini.clue').gen_clues.g()"; }
            { __raw = "require('mini.clue').gen_clues.marks()"; }
            { __raw = "require('mini.clue').gen_clues.registers()"; }
            { __raw = "require('mini.clue').gen_clues.windows()"; }
            { __raw = "require('mini.clue').gen_clues.z()"; }
          ];
        };
      };
    };

    # ==========================================================================
    # Treesitter
    # ==========================================================================
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings.max_lines = 3;
    };

    # ==========================================================================
    # UI Enhancements
    # ==========================================================================
    web-devicons.enable = true;

    notify = {
      enable = true;
      settings = {
        stages = "fade_in_slide_out";
        timeout = 3000;
        render = "default";
        max_width = 80;
        max_height = 10;
        top_down = true;
      };
    };

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
  };

  programs.nixvim.extraPackages = with pkgs; [ tree-sitter ];
}
