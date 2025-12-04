---
-- Bootstraps the plugin manager and sets up performance optimizations.
---

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    -- Don't lock plugins to a specific version (rolling updates)
    version = false,
  },
  -- Install the colorscheme immediately during bootstrap
  install = { colorscheme = { "onedark" } },
  checker = { enabled = true },
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
