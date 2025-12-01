---
-- Keymap configuration.
-- Defines global keybindings and utility functions for LSP mapping.
---

local M = {}
local map = vim.keymap.set

-- -----------------------------------------------------------------------------
-- Standard Operations
-- -----------------------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<leader>h", "<cmd>nohl<cr>", { desc = "Clear search highlights (Alternative)" })

-- -----------------------------------------------------------------------------
-- Window Navigation & Management
-- -----------------------------------------------------------------------------
-- Move focus (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- Resize windows (Ctrl + Arrows)
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- -----------------------------------------------------------------------------
-- Buffer Navigation
-- -----------------------------------------------------------------------------
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- -----------------------------------------------------------------------------
-- Editing Enhancements
-- -----------------------------------------------------------------------------
-- Continuous indentation in visual mode
map("v", "<", "<gv", { desc = "Indent selection left" })
map("v", ">", ">gv", { desc = "Indent selection right" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- -----------------------------------------------------------------------------
-- Plugin Specific
-- -----------------------------------------------------------------------------
-- (Empty as plugins manage their own keymaps or are replaced)

--- Registers LSP-related keymaps for a specific buffer.
--- @param bufnr number The buffer number to attach keymaps to.
function M.map_lsp_keymaps(bufnr)
  local function lsp_map(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  lsp_map("gd", vim.lsp.buf.definition, "Goto Definition")
  lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")
  lsp_map("K", vim.lsp.buf.hover, "Hover Documentation")
  lsp_map("gr", vim.lsp.buf.references, "Find References")
  lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  lsp_map("<leader>d", vim.diagnostic.open_float, "Show Line Diagnostics")
  lsp_map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
  lsp_map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

return M
