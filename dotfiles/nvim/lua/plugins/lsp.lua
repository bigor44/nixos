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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
                  expr = '(builtins.getFlake "/home/bigor/nixos").nixosConfigurations.grospc.options',
                },
              },
            },
          },
        },
      }

      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          client.server_capabilities.documentFormattingProvider = false
        end

        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Goto Definition")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("K", vim.lsp.buf.hover, "Hover")
        map("gr", vim.lsp.buf.references, "References")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
        map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
      end

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },

  -- Formatting
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

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    opts = { focus = true },
  },
}
