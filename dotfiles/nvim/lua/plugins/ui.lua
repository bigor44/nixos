---
-- UI Plugins.
-- Themes, statusline, icons, and visual enhancements.
---
return {
  -- Colorscheme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "darker", -- Example: set a specific style
        transparent = false,
      })
      require("onedark").load()
    end,
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
    },
    opts = {
      notify = { enabled = false },
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

  -- Mini.notify (Notification manager)
  {
    "echasnovski/mini.notify",
    version = false,
    config = function()
      require("mini.notify").setup()
      vim.notify = require("mini.notify").make_notify()
    end,
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

  -- Mini.clue (Keybinding helper)
  {
    "echasnovski/mini.clue",
    version = false,
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- G triggers
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- z commands
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
}
