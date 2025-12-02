return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("onedark").setup({
      style = "darker", -- Apply the 'darker' variant of One Dark
      transparent = false,
      -- You can add other configurations here if needed
    })
    require("onedark").load()
    vim.cmd.colorscheme("onedark")
  end,
}
