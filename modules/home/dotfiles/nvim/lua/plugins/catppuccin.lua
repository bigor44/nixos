return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        cmp = true,
        treesitter = true,
        native_lsp = { enabled = true },
        mini = { enabled = true }, -- Important pour mini.files et mini.statusline
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
