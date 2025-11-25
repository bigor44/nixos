return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-context" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "nix", "lua", "bash", "markdown", "json", "yaml", "vim", "vimdoc", "query" },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
    require("treesitter-context").setup({ max_lines = 3 })
  end,
}
