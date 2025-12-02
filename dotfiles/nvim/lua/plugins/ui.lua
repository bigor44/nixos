---
-- UI Plugins.
-- Themes and visual enhancements.
-- Most UI components are now handled by mini.nvim in mini.lua.
---
return {
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = false,
        blink_cmp = false,
        treesitter = true,
        gitsigns = false,
        noice = false,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
    },
  },
}
