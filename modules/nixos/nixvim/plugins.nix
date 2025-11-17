# modules/nixos/nixvim/plugins.nix
_: let
  lspServers = ["nil_ls" "bashls" "marksman"];
in {
  /*
  ---------------------------------------------------------------
  */
  lsp = {
    enable = true;
    servers =
      builtins.listToAttrs
      (map (n: {
          name = n;
          value = {enable = true;};
        })
        lspServers);
    keymaps.diagnostic = {
      "<leader>e" = "open_float";
      "[d" = "goto_prev";
      "]d" = "goto_next";
      "<leader>q" = "setloclist";
    };
    keymaps.lspBuf = {
      "gD" = "declaration";
      "gd" = "definition";
      "K" = "hover";
      "gi" = "implementation";
      "<C-k>" = "signature_help";
      "gr" = "references";
      "<leader>rn" = "rename";
      "<leader>ca" = "code_action";
      "<leader>D" = "type_definition";
    };
  };
  none-ls = {
    enable = true;
    sources.diagnostics = {
      statix.enable = true; # Nix linter
      deadnix.enable = true; # Find unused Nix code
    };
  };
  cmp = {
    enable = true;
    autoEnableSources = true;
    settings.mapping = {
      "<C-b>" = "cmp.mapping.scroll_docs(-4)";
      "<C-f>" = "cmp.mapping.scroll_docs(4)";
      "<C-Space>" = "cmp.mapping.complete()";
      "<C-e>" = "cmp.mapping.abort()";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<Tab>" = "cmp.mapping.select_next_item()";
      "<S-Tab>" = "cmp.mapping.select_prev_item()";
    };
    settings.sources = [
      {name = "nvim_lsp";}
      {name = "luasnip";}
      {name = "path";}
      {name = "buffer";}
    ];
  };
  luasnip.enable = true;
  cmp_luasnip.enable = true;

  conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        lsp_fallback = true;
        timeout_ms = 500;
      };
      formatters_by_ft = {
        nix = ["alejandra"];
        sh = ["shfmt"];
        bash = ["shfmt"];
        markdown = ["marksman"];
      };
    };
  };

  treesitter = {
    enable = true;
    nixGrammars = true;
    settings.highlight.enable = true;
    settings.indent.enable = true;
  };
  treesitter-context = {
    enable = true;
    settings.max_lines = 3;
  };

  neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      window.width = 30;
    };
  };
  telescope = {
    enable = true;
    extensions.fzf-native.enable = true;

    # plain mappings, no desc keys
    keymaps = {
      "<leader>ff" = "find_files";
      "<leader>fg" = "live_grep";
      "<leader>fb" = "buffers";
      "<leader>fh" = "help_tags";
    };
  };

  dap.enable = true;
  dap-ui = {
    enable = true;
    settings.layouts = [
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
  trouble = {
    enable = true;
    settings = {
      auto_open = false;
      auto_close = true;
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
        topdelete.text = "‾";
        changedelete.text = "~";
        untracked.text = "┆";
      };
    };
  };

  lualine.enable = true;
  noice.enable = true;
  web-devicons.enable = true;
  indent-blankline = {
    enable = true;
    settings.scope.enabled = true;
  };
  illuminate.enable = true;
  nvim-autopairs.enable = true;
  comment.enable = true;
  which-key = {
    enable = true;
    settings.delay = 500;
    settings.spec = [
      {
        __unkeyed-1 = "<leader>f";
        group = "Find";
      }
      {
        __unkeyed-1 = "<leader>c";
        group = "Code";
      }
      {
        __unkeyed-1 = "<leader>d";
        group = "Debug";
      }
      {
        __unkeyed-1 = "<leader>w";
        group = "Workspace";
      }
    ];
  };
  navbuddy = {
    enable = true;
    settings.lsp.auto_attach = true;
  };
  colorizer = {
    enable = true;
    settings.user_default_options.names = false;
  };

  persistence.enable = true;
}
