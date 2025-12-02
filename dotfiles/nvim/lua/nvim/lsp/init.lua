local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  local keymap = vim.keymap.set

  keymap("n", "gd", vim.lsp.buf.definition, opts)
  keymap("n", "K", vim.lsp.buf.hover, opts)
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  keymap("n", "gr", vim.lsp.buf.references, opts)
  keymap("n", "[d", vim.diagnostic.goto_prev, opts)
  keymap("n", "]d", vim.diagnostic.goto_next, opts)
end

local servers = {
  "bashls",
  "marksman",
  "pyright",
  "jsonls",
  "cssls",
  "html",
  "yamlls",
  "nixd",
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
  })
  vim.lsp.enable(server)
end

-- Lua specific settings
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.enable("lua_ls")
