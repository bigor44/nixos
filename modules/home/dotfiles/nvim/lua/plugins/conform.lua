return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "Format" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters_by_ft = {
      nix = { "nixfmt" },
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      json = { "prettier" },
      yaml = { "yamlfmt" },
      markdown = { "prettier" },
      python = { "isort", "black" }, -- Vous aviez ces paquets installés, autant les utiliser
      javascript = { "prettier" },
      typescript = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      toml = { "taplo" },
    },
  },
}
