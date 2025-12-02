local status, null_ls = pcall(require, "null-ls")
if not status then
  return
end

local formatting = null_ls.builtins.formatting

null_ls.setup({
  sources = {
    formatting.prettier, -- Web
    formatting.black, -- Python
    formatting.nixfmt, -- Nix
    formatting.stylua, -- Lua
    formatting.shfmt, -- Shell
    formatting.isort, -- Python imports
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(c)
              return c.name == "null-ls"
            end,
          })
        end,
      })
    end
  end,
})
