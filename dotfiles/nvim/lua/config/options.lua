local opt = vim.opt

-- -----------------------------------------------------------------------------
-- UI Options
-- -----------------------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.mouse = "a"

-- -----------------------------------------------------------------------------
-- Tab / Indentation
-- -----------------------------------------------------------------------------
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- -----------------------------------------------------------------------------
-- Search
-- -----------------------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true

-- -----------------------------------------------------------------------------
-- Performance / Behavior
-- -----------------------------------------------------------------------------
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.spelllang = { "en", "fr" }

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
