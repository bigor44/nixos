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
        gitsigns = true,
        neotree = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        native_lsp = { enabled = true },
        mini = { enabled = true },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
