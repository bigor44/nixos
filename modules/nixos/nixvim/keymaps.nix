[
  {
    mode = [
      "n"
      "v"
    ];
    key = "<leader>cf";
    action = "<cmd>Format<cr>";
    options.desc = "Format code";
  }

  # File explorer
  {
    mode = "n";
    key = "<leader>e";
    action = "<cmd>Neotree toggle<cr>";
    options.desc = "Toggle file explorer";
  }

  # Better window navigation
  {
    mode = "n";
    key = "<C-h>";
    action = "<C-w>h";
    options.desc = "Move to left window";
  }
  {
    mode = "n";
    key = "<C-j>";
    action = "<C-w>j";
    options.desc = "Move to bottom window";
  }
  {
    mode = "n";
    key = "<C-k>";
    action = "<C-w>k";
    options.desc = "Move to top window";
  }
  {
    mode = "n";
    key = "<C-l>";
    action = "<C-w>l";
    options.desc = "Move to right window";
  }

  # Resize windows
  {
    mode = "n";
    key = "<C-Up>";
    action = "<cmd>resize +2<cr>";
    options.desc = "Increase window height";
  }
  {
    mode = "n";
    key = "<C-Down>";
    action = "<cmd>resize -2<cr>";
    options.desc = "Decrease window height";
  }
  {
    mode = "n";
    key = "<C-Left>";
    action = "<cmd>vertical resize -2<cr>";
    options.desc = "Decrease window width";
  }
  {
    mode = "n";
    key = "<C-Right>";
    action = "<cmd>vertical resize +2<cr>";
    options.desc = "Increase window width";
  }

  # Better indenting
  {
    mode = "v";
    key = "<";
    action = "<gv";
    options.desc = "Indent left";
  }
  {
    mode = "v";
    key = ">";
    action = ">gv";
    options.desc = "Indent right";
  }

  # Move text up and down
  {
    mode = "v";
    key = "J";
    action = ":m '>+1<CR>gv=gv";
    options.desc = "Move text down";
  }
  {
    mode = "v";
    key = "K";
    action = ":m '<-2<CR>gv=gv";
    options.desc = "Move text up";
  }

  # Clear search highlighting
  {
    mode = "n";
    key = "<leader>h";
    action = "<cmd>nohlsearch<cr>";
    options.desc = "Clear search highlights";
  }

  # Buffer navigation
  {
    mode = "n";
    key = "<S-l>";
    action = "<cmd>bnext<cr>";
    options.desc = "Next buffer";
  }
  {
    mode = "n";
    key = "<S-h>";
    action = "<cmd>bprevious<cr>";
    options.desc = "Previous buffer";
  }

  # Debugger
  {
    mode = "n";
    key = "<leader>dui";
    action = "<cmd>DapUiToggle<cr>";
    options.desc = "Toggle DAP UI";
  }
  {
    mode = "n";
    key = "<leader>dt";
    action = "<cmd>DapToggleBreakpoint<cr>";
    options.desc = "Toggle breakpoint";
  }
  {
    mode = "n";
    key = "<leader>dc";
    action = "<cmd>DapContinue<cr>";
    options.desc = "Continue";
  }
  {
    mode = "n";
    key = "<leader>do";
    action = "<cmd>DapStepOver<cr>";
    options.desc = "Step over";
  }
  {
    mode = "n";
    key = "<leader>di";
    action = "<cmd>DapStepInto<cr>";
    options.desc = "Step into";
  }
  {
    mode = "n";
    key = "<leader>du";
    action = "<cmd>DapStepOut<cr>";
    options.desc = "Step out";
  }
]
