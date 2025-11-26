return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "nvim-treesitter/nvim-treesitter-context" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {},
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
    require("treesitter-context").setup({ max_lines = 3 })
  end,
}
