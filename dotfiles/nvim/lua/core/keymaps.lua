-- This file is for setting keybindings.
-- See `:help key-mapping` for details on creating keybindings.

-- set leader key to space
vim.g.mapleader = " "

local map = vim.api.nvim_set_keymap

-- normal mode
-- change window
map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

-- resize window
map("n", "<C-Up>", ":resize -2<CR>", { noremap = true, silent = true })
map("n", "<C-Down>", ":resize +2<CR>", { noremap = true, silent = true })
map("n", "<C-Left>", ":resize -2<CR>", { noremap = true, silent = true })
map("n", "<C-Right>", ":resize +2<CR>", { noremap = true, silent = true })

-- move line
map("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })

-- visual mode
-- move line
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- stay in indent mode
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et
