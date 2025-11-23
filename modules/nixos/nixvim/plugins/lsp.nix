{
  programs.nixvim.plugins = {
    # --- LSP & Servers ---
    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        bashls.enable = true;
        marksman.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
      };
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

    # --- Autocompletion (CMP) ---
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        formatting = {
          fields = ["kind" "abbr" "menu"];
          expandable_indicator = true;
        };
        mapping = {
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
        ];
      };
    };

    # --- Snippets ---
    luasnip.enable = true;
    cmp_luasnip.enable = true;

    # --- Formatting ---
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

    # --- UI Enhancements for LSP ---
    lspkind = {
      enable = true;
      cmp.enable = true;
      settings.cmp.menu = {
        nvim_lsp = "[LSP]";
        luasnip = "[Snip]";
        buffer = "[Buf]";
        path = "[Path]";
      };
    };

    schemastore = {
      enable = true;
      json.enable = true;
      yaml.enable = true;
    };
  };
}
