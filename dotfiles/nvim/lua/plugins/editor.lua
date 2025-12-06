---
-- Editor Plugins.
-- Fuzzy finder, file explorer, version control, and other editor utilities.
---
return {
  -- ---------------------------------------------------------------------------
  -- Telescope (Fuzzy Finder)
  -- ---------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make", -- Compiles fzf-native for speed
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "^.git/", "^node_modules/" },
        layout_config = {
          horizontal = { prompt_position = "top" },
        },
        sorting_strategy = "ascending",
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Mini.files (File Explorer)
  -- ---------------------------------------------------------------------------
  {
    "echasnovski/mini.files",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open mini.files (cwd)",
      },
    },
    opts = {
      windows = {
        preview = true,
        width_focus = 30,
        width_preview = 30,
      },
      options = {
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Mini.hipatterns (Highlight patterns & Todo)
  -- ---------------------------------------------------------------------------
  {
    "echasnovski/mini.hipatterns",
    version = false,
    event = "BufReadPre",
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight hex color strings
          hex_color = hipatterns.gen_highlighter.hex_color(),

          -- Highlight Todo comments
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        },
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- LazyGit
  -- ---------------------------------------------------------------------------
  -- Terminal UI for Git integrated into Neovim.
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    },
  },
}
