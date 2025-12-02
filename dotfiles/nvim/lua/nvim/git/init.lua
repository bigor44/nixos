local status_gitsigns, gitsigns = pcall(require, "gitsigns")
if status_gitsigns then
  gitsigns.setup()
end

local status_lazygit, _ = pcall(require, "lazygit")
-- Lazygit keymap
if status_lazygit then
  vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
end

-- git.nvim setup if needed, though gitsigns covers most signs/hunks.
-- If requested explicitly:
local status_git, git = pcall(require, "git")
if status_git then
  git.setup()
end
