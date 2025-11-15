{pkgs, ...}: {
  # Color scheme
  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "moon";
      transparent = false;
    };
  };

  # Plugins
  plugins = {
    # LSP
    lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true; # Nix LSP
        bashls.enable = true; # Bash LSP
        marksman.enable = true; # Markdown LSP
      };
      keymaps = {
        diagnostic = {
          "<leader>e" = "open_float";
          "[d" = "goto_prev";
          "]d" = "goto_next";
          "<leader>q" = "setloclist";
        };
        lspBuf = {
          "gD" = "declaration";
          "gd" = "definition";
          "K" = "hover";
          "gi" = "implementation";
          "<C-k>" = "signature_help";
          "<leader>wa" = "add_workspace_folder";
          "<leader>wr" = "remove_workspace_folder";
          "<leader>D" = "type_definition";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
          "gr" = "references";
        };
      };
    };

    # Advanced formatting
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lspFallback = true;
          timeoutMs = 500;
        };
        formattersByFt = {
          nix = ["alejandra"];
          sh = ["shfmt"];
          bash = ["shfmt"];
          markdown = ["marksman"];
        };
      };
    };

    # Autocompletion
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "nvim_lsp_signature_help";}
          {name = "git";}
          {name = "path";}
          {name = "buffer";}
        ];
      };
    };
    cmp-git.enable = true;

    # Snippet engine
    luasnip.enable = true;
    cmp_luasnip.enable = true;

    # Treesitter
    treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection.enable = true;
      };
    };

    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 3;
      };
    };

    # Status line
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "tokyonight";
          icons_enabled = true;
          component_separators = {
            left = "|";
            right = "|";
          };
          section_separators = {
            left = "";
            right = "";
          };
        };
      };
    };

    # File explorer
    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        window = {
          width = 30;
        };
      };
    };

    # Telescope - Fuzzy finder
    telescope = {
      enable = true;
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
      extensions = {
        fzf-native.enable = true;
      };
    };

    # Debugger (DAP)
    dap = {
      enable = true;
    };
    dap-ui = {
      enable = true;
      settings = {
        layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 0.25;
              }
              {
                id = "breakpoints";
                size = 0.25;
              }
              {
                id = "stacks";
                size = 0.25;
              }
              {
                id = "watches";
                size = 0.25;
              }
            ];
            position = "left";
            size = 40;
          }
          {
            elements = [
              {
                id = "repl";
                size = 0.5;
              }
              {
                id = "console";
                size = 0.5;
              }
            ];
            position = "bottom";
            size = 10;
          }
        ];
      };
    };

    # Git integration
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
        signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
          untracked.text = "┆";
        };
      };
    };

    # Session management
    persistence = {
      enable = true;
    };

    # UI enhancements
    noice = {
      enable = true;
    };

    web-devicons.enable = true;

    # Indent guides
    indent-blankline = {
      enable = true;
      settings = {
        scope.enabled = true;
      };
    };

    # Highlight current word
    illuminate = {
      enable = true;
      settings = {
        under_cursor = false;
        filetypes_denylist = [
          "neo-tree"
          "TelescopePrompt"
        ];
      };
    };

    # Auto pairs
    nvim-autopairs.enable = true;

    # Comments
    comment.enable = true;

    # Better navigation
    which-key = {
      enable = true;
      settings = {
        delay = 500;
        spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "Workspace";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>d";
            group = "Debug";
          }
        ];
      };
    };

    # Breadcrumbs
    navbuddy = {
      enable = true;
      settings = {
        lsp.auto_attach = true;
      };
    };

    # Colorizer for color codes
    colorizer = {
      enable = true;
      settings = {
        user_default_options = {
          names = false;
        };
      };
    };

    # Spell checking
    # Note: NixVim doesn't have a spell plugin, it's built into vim
  };

  # Extra packages needed
  extraPackages = with pkgs; [
    # LSP servers
    nil
    bash-language-server
    marksman

    # Formatters
    alejandra
    shfmt

    # Ripgrep for telescope
    ripgrep
    fd
  ];
}
