return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = { signs = true },
  keys = { { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" } },
}
