[
  {
    event = "TextYankPost";
    command = "silent! lua vim.highlight.on_yank { timeout=250 }";
  }
  {
    event = ["BufEnter"];
    pattern = "*";
    command = "setlocal formatoptions-=ro";
  }
]
