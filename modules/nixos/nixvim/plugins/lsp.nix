{
  # ============================================================================
  # Language Server Protocol (LSP)
  # ============================================================================
  # Configures intelligent code features:
  # - LSP Servers (Nix, Lua, Python, etc.)
  # - Formatting (Conform)
  # - Autocompletion (Blink-cmp)
  # - Diagnostics (Trouble)
  # ============================================================================
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        marksman.enable = true;
        pyright.enable = true;
        jsonls = {
          enable = true;
          settings.json = {
            schemas = {__raw = "require('schemastore').json.schemas()";};
            validate.enable = true;
          };
        };
        yamlls = {
          enable = true;
          settings.yaml = {
            schemaStore.enable = false;
            schemas = {__raw = "require('schemastore').yaml.schemas()";};
          };
        };
        lua_ls = {
          enable = true;
          settings.Lua = {
            workspace.checkThirdParty = false;
            telemetry.enable = false;
            format.enable = false;
          };
        };
        nixd = {
          enable = true;
          settings.nixd = {
            nixpkgs.expr = "import <nixpkgs> { }";
            formatting.command = ["alejandra"];
            options.nixos.expr = "(builtins.getFlake \"/home/bigor/nixos\").nixosConfigurations.grospc.options";
          };
        };
      };
      keymaps = {
        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "K" = "hover";
          "gr" = "references";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
        };
        diagnostic = {
          "<leader>d" = "open_float";
          "[d" = "goto_prev";
          " ]d" = "goto_next";
        };
      };
    };

    schemastore = {
      enable = true;
      json.enable = true;
      yaml.enable = true;
    };

    conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        format_on_save = {
          timeout_ms = 500;
          lsp_fallback = true;
        };
        formatters_by_ft = {
          nix = ["alejandra"];
          lua = ["stylua"];
          sh = ["shfmt"];
          bash = ["shfmt"];
          json = ["prettier"];
          yaml = ["prettier"];
          markdown = ["prettier"];
          python = ["isort" "black"];
          javascript = ["prettier"];
          typescript = ["prettier"];
          css = ["prettier"];
          html = ["prettier"];
          toml = ["taplo"];
        };
        formatters = {
          shfmt = {
            prepend_args = ["-i" "2" "-s"];
          };
        };
      };
    };

    blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "default";
        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";
        };
        sources.default = ["lsp" "path" "snippets" "buffer"];
        completion = {
          menu.border = "rounded";
          documentation.window.border = "rounded";
        };
        signature.enabled = true;
      };
    };

    trouble = {
      enable = true;
      settings = {
        focus = true;
      };
    };
  };
}
