---
-- UI Plugins.
-- Themes, statusline, icons, and visual enhancements.
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
        blink_cmp = true,
        treesitter = true,
        gitsigns = true,
        snacks = true,
        noice = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
    },
  },

  -- Mini.nvim Suite (Statusline, Tabline, Icons, etc.)
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.statusline").setup()
      require("mini.tabline").setup()
      require("mini.cursorword").setup()
      require("mini.indentscope").setup()
      require("mini.icons").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.comment").setup()
      require("mini.trailspace").setup()
    end,
  },

  -- Git Signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
      },
    },
  },

  -- Noice (UI Enhancements for messages, cmdline, and popupmenu)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  -- Notify (Notification manager)
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },

  -- Dressing (Better UI for input/select)
  {
    "stevearc/dressing.nvim",
    opts = {
      input = { enabled = true },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
      },
    },
  },

  -- Colorizer (Highlight color codes)
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        names = false,
        RGB = true,
        RRGGBB = true,
      },
    },
  },

  -- Which Key (Keybinding helper)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
