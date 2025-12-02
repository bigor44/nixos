local opt = vim.opt
local g = vim.g

-- Globals
g.mapleader = " "
g.maplocalleader = " "

-- Options
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.wrap = false
opt.breakindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.clipboard = "unnamedplus"

-- Keymaps
local keymap = vim.keymap.set
-- Save with Ctrl+S
keymap("n", "<C-s>", ":w<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })

-- Clear highlights
keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear highlights" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Theme
vim.g.sonokai_style = "andromeda"
vim.g.sonokai_better_performance = 1
vim.cmd.colorscheme("sonokai")
