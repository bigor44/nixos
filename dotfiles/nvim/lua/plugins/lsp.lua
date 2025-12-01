return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "nix", "bash", "markdown", "markdown_inline", "json", "yaml", "python" },
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { max_lines = 3 },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
    config = function()
      -- Récupération des capacités pour blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local keymaps = require("config.keymaps")
      local hostname = vim.fn.hostname()
      local home = vim.loop.os_homedir()
      local flake_path = home .. "/nixos"

      -- Définition des serveurs
      local servers = {
        bashls = {},
        marksman = {},
        pyright = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              format = { enable = false },
            },
          },
        },
        nixd = {
          settings = {
            nixd = {
              nixpkgs = { expr = "import <nixpkgs> { }" },
              formatting = { command = { "nixfmt" } },
              options = {
                nixos = {
                  expr = string.format('(builtins.getFlake "%s").nixosConfigurations.%s.options', flake_path, hostname),
                },
              },
            },
          },
        },
      }

      local on_attach = function(client, bufnr)
        -- Désactiver le formatage LSP si nécessaire (ex: si on préfère conform.nvim)
        if client.server_capabilities.documentFormattingProvider then
          client.server_capabilities.documentFormattingProvider = false
        end
        keymaps.map_lsp_keymaps(bufnr)
      end

      -- CORRECTION : Utilisation de l'API native pour Neovim 0.11+
      -- On n'utilise plus require("lspconfig")[server].setup()
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach

        -- Configuration native (Neovim 0.11+ / lspconfig 3.0)
        -- 'vim.lsp.config' enregistre la configuration pour le serveur donné
        vim.lsp.config(server, config)

        -- 'vim.lsp.enable' active le serveur (client)
        vim.lsp.enable(server)
      end
    end,
  },

  -- Formatting (inchangé)
  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = true,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        nix = { "nixfmt" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        json = { "prettier" },
        yaml = { "yamlfmt" },
        markdown = { "prettier" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        toml = { "taplo" },
      },
    },
  },

  -- Autocompletion (inchangé)
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = "rafamadriz/friendly-snippets",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
      signature = { enabled = true },
    },
  },

  -- Trouble (inchangé)
  {
    "folke/trouble.nvim",
    opts = { focus = true },
  },
}
