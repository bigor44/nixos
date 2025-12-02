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
  -- Neo-tree (File Explorer)
  -- ---------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        bind_to_cwd = false, -- Don't change Neovim's CWD when changing dirs in tree
        follow_current_file = { enabled = true }, -- Highlight current file in tree
      },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "git_status" },
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Todo Comments
  -- ---------------------------------------------------------------------------
  -- Highlights TODO, FIXME, HACK, etc. in comments.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
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
