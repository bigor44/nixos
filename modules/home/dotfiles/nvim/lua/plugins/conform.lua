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
      nix = { "treefmt" },
      lua = { "treefmt" },
      sh = { "treefmt" },
      bash = { "treefmt" },
      json = { "treefmt" },
      yaml = { "treefmt" },
      markdown = { "treefmt" },
      python = { "treefmt" },
    },
  },
}
