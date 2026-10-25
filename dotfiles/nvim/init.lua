-- Entry point for Neovim's configuration (symlinked to ~/.config/nvim by modules/home/dotfiles.nix).
-- Sets the leader, then loads the core modules from lua/core/.

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
