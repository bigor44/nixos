{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # ========================================================================== #
    #  OPTIONS
    # ========================================================================== #
    opts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 300;
      undofile = true;
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
      mouse = "a";
      spelllang = [
        "en"
        "fr"
      ];
    };

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    # ========================================================================== #
    #  AUTOCOMMANDES
    # ========================================================================== #
    autoCmd = [
      {
        event = [ "TextYankPost" ];
        pattern = [ "*" ];
        group = "HighlightYank";
        callback = {
          __raw = "function() vim.highlight.on_yank({ timeout = 250 }) end";
        };
      }
      {
        event = [ "BufEnter" ];
        pattern = [ "*" ];
        callback = {
          __raw = "function() vim.opt_local.formatoptions:remove({ 'r', 'o' }) end";
        };
      }
    ];

    autoGroups = {
      HighlightYank = {
        clear = true;
      };
    };

    # ========================================================================== #
    #  KEYMAPS
    # ========================================================================== #
    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>h";
        action = "<cmd>nohl<cr>";
        options.desc = "Clear search highlight";
      }
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Go left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Go down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Go up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Go right";
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Height +";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Height -";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Width -";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Width +";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Prev buffer";
      }
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move line down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move line up";
      }
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options.desc = "Indent left";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options.desc = "Indent right";
      }

      # Mini.files
      {
        mode = "n";
        key = "<leader>e";
        action = ''<cmd>lua if not require("mini.files").close() then require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end<CR>'';
        options.desc = "File Explorer (toggle)";
      }
      {
        mode = "n";
        key = "<leader>E";
        action = ''<cmd>lua require("mini.files").open(vim.loop.cwd(), true)<CR>'';
        options.desc = "File Explorer (cwd)";
      }

      # Mini.pick
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Pick files<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Pick grep_live<CR>";
        options.desc = "Live Grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Pick buffers<CR>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Pick help<CR>";
        options.desc = "Help Tags";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Pick resume<CR>";
        options.desc = "Resume Last Pick";
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>Pick grep_live<CR>";
        options.desc = "Search in Project";
      }

      # Mini.diff
      {
        mode = "n";
        key = "]h";
        action = ''<cmd>lua require("mini.diff").goto_hunk("next")<CR>'';
        options.desc = "Next Hunk";
      }
      {
        mode = "n";
        key = "[h";
        action = ''<cmd>lua require("mini.diff").goto_hunk("prev")<CR>'';
        options.desc = "Previous Hunk";
      }

      # Snacks
      {
        mode = "n";
        key = "<leader>gg";
        action = ''<cmd>lua Snacks.lazygit()<CR>'';
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gf";
        action = ''<cmd>lua Snacks.lazygit.log_file()<CR>'';
        options.desc = "Lazygit Current File History";
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = ''<cmd>lua Snacks.lazygit.log()<CR>'';
        options.desc = "Lazygit Log (Cwd)";
      }
      {
        mode = "n";
        key = "<c-t>";
        action = ''<cmd>lua Snacks.terminal.toggle()<CR>'';
        options.desc = "Toggle Terminal";
      }
      {
        mode = "n";
        key = "<c-_>";
        action = ''<cmd>lua Snacks.terminal.toggle()<CR>'';
        options.desc = "Toggle Terminal";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ''<cmd>lua Snacks.bufdelete()<CR>'';
        options.desc = "Delete Buffer";
      }
      {
        mode = "n";
        key = "<leader>n";
        action = ''<cmd>lua Snacks.notifier.show_history()<CR>'';
        options.desc = "Notification History";
      }
      {
        mode = "n";
        key = "<leader>un";
        action = ''<cmd>lua Snacks.notifier.hide()<CR>'';
        options.desc = "Dismiss All Notifications";
      }

      # Trouble
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics";
      }
    ];

    # ========================================================================== #
    #  PLUGINS
    # ========================================================================== #
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
      # --- Treesitter ---
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

      # --- Snacks ---
      snacks = {
        enable = true;
        settings = {
          bigfile.enabled = true;
          quickfile.enabled = true;

          # Correction du Dashboard pour Nixvim
          dashboard = {
            enabled = true;
            # On redéfinit les sections pour supprimer "startup" qui dépend de lazy.nvim
            sections = [
              { section = "header"; }
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
              {
                section = "recent_files";
                icon = " ";
                title = "Recent Files";
                indent = 2;
                padding = 1;
              }
              {
                section = "projects";
                icon = " ";
                title = "Projects";
                indent = 2;
                padding = 1;
              }
            ];
          };

          notifier.enabled = true;
          statuscolumn.enabled = true;
          bufdelete.enabled = true;
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
                __raw = ''
                  function()
                    local height = math.floor(0.618 * vim.o.lines)
                    local width = math.floor(0.618 * vim.o.columns)
                    return {
                      anchor = "NW",
                      height = height,
                      width = width,
                      row = math.floor(0.5 * (vim.o.lines - height)),
                      col = math.floor(0.5 * (vim.o.columns - width)),
                      border = "rounded",
                    }
                  end
                '';
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
              __raw = ''require("mini.diff").gen_source.git()'';
            };
            delay = {
              text_change = 200;
            };
          };
          hipatterns = {
            highlighters = {
              hex_color = {
                __raw = ''require("mini.hipatterns").gen_highlighter.hex_color()'';
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
                __raw = ''require("mini.indentscope").gen_animation.none()'';
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

      # --- LSP ---
      lsp = {
        enable = true;
        onAttach = ''
          if client.server_capabilities.documentFormattingProvider then
            client.server_capabilities.documentFormattingProvider = false
          end
        '';
        keymaps = {
          silent = true;
          lspBuf = {
            gd = "definition";
            gD = "declaration";
            K = "hover";
            gr = "references";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
          diagnostic = {
            "<leader>e" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
        };
        servers = {
          bashls.enable = true;
          marksman.enable = true;
          pyright.enable = true;
          jsonls = {
            enable = true;
            settings = {
              json = {
                schemas = {
                  __raw = "require('schemastore').json.schemas()";
                };
                validate = {
                  enable = true;
                };
              };
            };
          };
          yamlls = {
            enable = true;
            settings = {
              yaml = {
                schemaStore = {
                  enable = false;
                  url = "";
                };
                schemas = {
                  __raw = "require('schemastore').yaml.schemas()";
                };
              };
            };
          };
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false;
                };
                telemetry = {
                  enable = false;
                };
                format = {
                  enable = false;
                };
              };
            };
          };
          nixd = {
            enable = true;
            settings = {
              nixd = {
                nixpkgs = {
                  expr = "import <nixpkgs> { }";
                };
                formatting = {
                  command = [ "nixfmt" ];
                };
                options = {
                  nixos = {
                    expr = ''(builtins.getFlake "/home/bigor/nixos").nixosConfigurations.grospc.options'';
                  };
                };
              };
            };
          };
        };
      };

      schemastore = {
        enable = true;
        json.enable = true;
        yaml.enable = true;
      };

      # --- Formatting ---
      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            lua = [ "stylua" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            json = [ "prettier" ];
            yaml = [ "yamlfmt" ];
            markdown = [ "prettier" ];
            python = [
              "isort"
              "black"
            ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            css = [ "prettier" ];
            html = [ "prettier" ];
            toml = [ "taplo" ];
          };
        };
      };

      # --- Autocompletion ---
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
          window = {
            completion = {
              border = "rounded";
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
            };
            documentation = {
              border = "rounded";
            };
          };
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" =
              "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end, { 'i', 's' })";
            "<S-Tab>" =
              "cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end, { 'i', 's' })";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

      lspkind = {
        enable = true;
        settings = {
          cmp = {
            enable = true;
            max_width = 50;
            ellipsis_char = "...";
          };
        };
      };

      luasnip.enable = true;

      # --- Trouble ---
      trouble = {
        enable = true;
        settings = {
          focus = true;
        };
      };
    };

    # ========================================================================== #
    #  DÉPENDANCES SUPPLÉMENTAIRES
    # ========================================================================== #
    extraPackages = with pkgs; [
      ripgrep
      fd
      wl-clipboard
      gcc
      nixfmt-rfc-style
      stylua
      shfmt
      yamlfmt
      isort
      black
      taplo
      nodePackages.prettier
    ];
  };
}
