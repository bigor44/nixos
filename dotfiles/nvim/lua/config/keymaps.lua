local M = {}
local map = vim.keymap.set

-- Standard Operations
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>h", "<cmd>nohl<cr>", { desc = "Clear search highlight" })

-- Window Navigation (Ctrl+hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Go left" })
map("n", "<C-j>", "<C-w>j", { desc = "Go down" })
map("n", "<C-k>", "<C-w>k", { desc = "Go up" })
map("n", "<C-l>", "<C-w>l", { desc = "Go right" })

-- Resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Height +" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Height -" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Width -" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Width +" })

-- Buffer Navigation (Shift+hl)
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })

-- Indentation Mode Visual
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move Lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Diagnostics (Trouble)
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })

function M.map_lsp_keymaps(bufnr)
  local lsp_map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  lsp_map("gd", vim.lsp.buf.definition, "Goto Definition")
  lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")
  lsp_map("K", vim.lsp.buf.hover, "Hover")
  lsp_map("gr", vim.lsp.buf.references, "References")
  lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename")
  lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  lsp_map("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
  lsp_map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  lsp_map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

return M
