---
-- Mini.nvim Suite.
-- A collection of minimal, fast, and modular Lua plugins.
-- Replacing: Telescope, Neo-tree, Gitsigns, WhichKey, Todo-comments, Colorizer, etc.
---
return {
  {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    config = function()
      -- Basics
      require("mini.basics").setup()
      require("mini.misc").setup()

      -- UI & Visuals
      require("mini.statusline").setup()
      require("mini.tabline").setup()
      require("mini.icons").setup()
      require("mini.cursorword").setup()
      require("mini.indentscope").setup()
      require("mini.notify").setup()
      require("mini.starter").setup()

      -- Editing
      require("mini.pairs").setup()
      require("mini.surround").setup()
      require("mini.comment").setup()
      require("mini.trailspace").setup()
      require("mini.splitjoin").setup()
      require("mini.move").setup()
      require("mini.ai").setup()
      require("mini.align").setup()
      require("mini.operators").setup()

      -- Navigation & Files
      require("mini.files").setup()
      require("mini.bracketed").setup()
      require("mini.jump").setup()
      require("mini.jump2d").setup()
      require("mini.visits").setup()

      -- Git
      require("mini.git").setup()
      require("mini.diff").setup()

      -- Completion & Picking
      require("mini.completion").setup({
        lsp_completion = {
          source_func = "completefunc",
          auto_setup = true,
          process_items = function(items)
            -- Filter out snippets if you don't want them, or process them
            return items
          end,
        },
      })
      require("mini.pick").setup()
      require("mini.extra").setup()

      -- Key Helper (WhichKey replacement)
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- G keys
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

          -- z key
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

      -- Highlight Patterns (Todo & Colorizer replacement)
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Fixme, Todo, Hack, etc.
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Hex colors
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
    keys = {
      -- File Explorer (Mini.files)
      {
        "<leader>e",
        function()
          local MiniFiles = require("mini.files")
          if not MiniFiles.close() then
            MiniFiles.open()
          end
        end,
        desc = "File Explorer (Mini Files)",
      },

      -- Picker (Telescope replacement)
      { "<leader>ff", "<cmd>Pick files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Pick help<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>Pick oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fd", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics" },

      -- Git (Mini.git)
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git Log" },
      { "<leader>gs", "<cmd>Git status<cr>", desc = "Git Status" },
    },
  },
}
