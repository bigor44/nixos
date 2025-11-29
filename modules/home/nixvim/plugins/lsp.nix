{
  config,
  pkgs,
  osConfig,
  ...
}:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      treesitter-textobjects = {
        enable = true;
        settings = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
            };
          };
        };
      };

      treesitter-context = {
        enable = true;
        settings.max_lines = 3;
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
            "<leader>d" = "open_float"; # Changed from <leader>e to avoid conflict
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
                    # Dynamic path to flake and dynamic hostname
                    expr = ''(builtins.getFlake "${config.home.homeDirectory}/nixos").nixosConfigurations.${osConfig.networking.hostName}.options'';
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

      luasnip = {
        enable = true;
        # Enable friendly-snippets
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };

      # --- Trouble ---
      trouble = {
        enable = true;
        settings = {
          focus = true;
        };
      };
    };
  };
}
