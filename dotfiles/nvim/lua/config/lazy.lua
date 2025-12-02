---
-- Lazy.nvim configuration.
-- Bootstraps the plugin manager and sets up performance optimizations.
---

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- -----------------------------------------------------------------------------
-- Bootstrap
-- -----------------------------------------------------------------------------
-- Clone lazy.nvim if it doesn't exist to ensure automatic setup on new machines.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- Setup
-- -----------------------------------------------------------------------------
require("lazy").setup({
  -- Load plugins from the lua/plugins directory
  spec = {
    { import = "plugins" },
  },
  defaults = {
    -- Load plugins immediately unless specified otherwise
    lazy = false,
    -- Don't lock plugins to a specific version (rolling updates)
    version = false,
  },
  -- Install the colorscheme immediately during bootstrap
  install = { colorscheme = { "onedark" } },
  checker = { enabled = true }, -- Check for updates automatically
  performance = {
    rtp = {
      -- Disable standard plugins we don't use to improve startup time
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
