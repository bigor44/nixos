--  It is the main entry point for Neovim's configuration.
--  It is responsible for loading the entire configuration.

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must be set before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load options and keymaps
require("core.options")
require("core.keymaps")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
