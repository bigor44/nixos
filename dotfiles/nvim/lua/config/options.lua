-- Neovim options configuration.
-- Sets up global, window, and buffer-local options.

local opt = vim.opt

-- -----------------------------------------------------------------------------
-- UI Options
-- -----------------------------------------------------------------------------
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers for easier jumps
opt.termguicolors = true -- Enable 24-bit RGB color support
opt.signcolumn = "yes" -- Always show sign column to prevent text shifting
opt.cursorline = true -- Highlight the current line
opt.scrolloff = 8 -- Keep 8 lines of context above/below cursor
opt.mouse = "a" -- Enable mouse support in all modes

-- -----------------------------------------------------------------------------
-- Tab / Indentation
-- -----------------------------------------------------------------------------
opt.tabstop = 2 -- Number of spaces a tab counts for
opt.shiftwidth = 2 -- Size of an indent
opt.expandtab = true -- Use spaces instead of actual tabs
opt.smartindent = true -- Insert indents automatically based on syntax

-- -----------------------------------------------------------------------------
-- Search
-- -----------------------------------------------------------------------------
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Override ignorecase if search contains capitals

-- -----------------------------------------------------------------------------
-- Performance / Behavior
-- -----------------------------------------------------------------------------
opt.updatetime = 250 -- Decrease update time for faster event triggers
opt.timeoutlen = 300 -- Time (ms) to wait for a mapped sequence to complete
opt.undofile = true -- Enable persistent undo across sessions
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect" -- Better completion menu experience
opt.spelllang = { "en", "fr" } -- Spellcheck languages

-- -----------------------------------------------------------------------------
-- Globals
-- -----------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- -----------------------------------------------------------------------------
-- Auto Commands
-- -----------------------------------------------------------------------------

---
-- Creates a dedicated augroup for the configuration to prevent duplication.
-- @param name string The name suffix for the augroup.
-- @return number The augroup ID.
--
local function augroup(name)
  return vim.api.nvim_create_augroup("gemini_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 250 })
  end,
})

-- Disable automatic comment insertion on new lines
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})
