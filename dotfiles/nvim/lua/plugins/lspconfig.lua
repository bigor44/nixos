return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "b0o/schemastore.nvim",
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    -- 1. Capabilities (pour nvim-cmp)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- 2. Keymaps & Formatage via LspAttach (Méthode native 0.11)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Désactive le formatage du LSP pour éviter les conflits avec Conform.nvim
        if client.server_capabilities.documentFormattingProvider then
          client.server_capabilities.documentFormattingProvider = false
        end

        -- Keymaps
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

    -- 3. Définition des Serveurs
    local servers = { "bashls", "marksman", "jsonls", "yamlls", "lua_ls", "nixd", "pyright" }

    for _, server in ipairs(servers) do
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
            -- "diagnostics.globals" est retiré car géré par lazydev.nvim
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- On s'assure que lua_ls ne formate pas (on utilise stylua via conform)
            format = { enable = false },
          },
        }
      elseif server == "nixd" then
        opts.settings = {
          nixd = {
            nixpkgs = { expr = "import <nixpkgs> { }" },
            formatting = { command = { "nixfmt" } },
            options = {
              nixos = {
                expr = string.format(
                  '(builtins.getFlake "%s").nixosConfigurations.%s.options',
                  vim.env.NIXOS_FLAKE_PATH or "/home/bigor/nixos", -- Fallback to hardcoded path
                  vim.env.NIXOS_HOSTNAME or "grospc" -- Fallback to desktop
                ),
              },
            },
          },
        }
      end

      -- 4. Activation Native (Pure 0.11)
      -- On configure le serveur dans le registre interne de Neovim
      vim.lsp.config(server, opts)
      -- On l'active (ce qui déclenche le téléchargement de la config par défaut depuis nvim-lspconfig si besoin)
      vim.lsp.enable(server)
    end
  end,
}
