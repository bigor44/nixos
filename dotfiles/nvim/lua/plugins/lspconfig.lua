return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "b0o/schemastore.nvim",
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    -- 1. Signes (Icônes)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- 2. Configuration des Serveurs
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local servers = { "nixd", "bashls", "marksman", "jsonls", "yamlls", "lua_ls" }

    for _, server in ipairs(servers) do
      -- On définit nos options personnelles
      local opts = {
        capabilities = capabilities,
      }

      -- Configurations Spécifiques
      if server == "jsonls" then
        opts.settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        }
      elseif server == "yamlls" then
        opts.settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        }
      elseif server == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        }
      elseif server == "nixd" then
        opts.settings = {
          nixd = { formatting = { command = { "nixfmt" } } },
        }
      end

      -- 3. Activation (Neovim 0.11 s'occupe de fusionner avec les défauts de nvim-lspconfig)
      vim.lsp.config(server, opts)
      vim.lsp.enable(server)
    end

    -- 4. Keymaps lors de l'attachement (LspAttach est la méthode recommandée)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        local map = vim.keymap.set
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gD", vim.lsp.buf.declaration, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        map("n", "<leader>e", vim.diagnostic.open_float, opts)
        map("n", "[d", vim.diagnostic.goto_prev, opts)
        map("n", "]d", vim.diagnostic.goto_next, opts)
      end,
    })
  end,
}
