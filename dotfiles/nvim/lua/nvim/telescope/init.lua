local status, telescope = pcall(require, "telescope")
if not status then
  return
end

local builtin = require("telescope.builtin")
local keymap = vim.keymap.set

telescope.setup({
  defaults = {
    file_ignore_patterns = { ".git/", "node_modules" },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
  },
})

-- Keymaps
keymap("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
keymap("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
