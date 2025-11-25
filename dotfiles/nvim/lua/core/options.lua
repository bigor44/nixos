-- ========================================================================== --
--  OPTIONS GLOBALES
-- ========================================================================== --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Visuel & Interface
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Comportement
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.mouse = "a"

-- Langue
opt.spelllang = { "en", "fr" }

