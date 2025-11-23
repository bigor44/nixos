[
  # ---------- general ----------
  {
    mode = "n";
    key = "<leader>h";
    action = "<cmd>nohl<cr>";
    options.desc = "Clear search highlight";
  }

  # ---------- window ----------
  {
    mode = "n";
    key = "<C-h>";
    action = "<C-w>h";
    options.desc = "Go left";
  }
  {
    mode = "n";
    key = "<C-j>";
    action = "<C-w>j";
    options.desc = "Go down";
  }
  {
    mode = "n";
    key = "<C-k>";
    action = "<C-w>k";
    options.desc = "Go up";
  }
  {
    mode = "n";
    key = "<C-l>";
    action = "<C-w>l";
    options.desc = "Go right";
  }

  # ---------- resize ----------
  {
    mode = "n";
    key = "<C-Up>";
    action = "<cmd>resize +2<cr>";
    options.desc = "Height +";
  }
  {
    mode = "n";
    key = "<C-Down>";
    action = "<cmd>resize -2<cr>";
    options.desc = "Height –";
  }
  {
    mode = "n";
    key = "<C-Left>";
    action = "<cmd>vertical resize -2<cr>";
    options.desc = "Width –";
  }
  {
    mode = "n";
    key = "<C-Right>";
    action = "<cmd>vertical resize +2<cr>";
    options.desc = "Width +";
  }

  # ---------- buffer ----------
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
    options.desc = "Prev buffer";
  }

  # ---------- explorer ----------
  {
    mode = "n";
    key = "<leader>e";
    action = "<cmd>Neotree toggle<cr>";
    options.desc = "Explorer";
  }

  # ---------- format ----------
  {
    mode = ["n" "v"];
    key = "<leader>cf";
    action = "<cmd>Format<cr>";
    options.desc = "Format";
  }

  # ---------- debug ----------
  {
    mode = "n";
    key = "<leader>dt";
    action = "<cmd>DapToggleBreakpoint<cr>";
    options.desc = "BP toggle";
  }
  {
    mode = "n";
    key = "<leader>dc";
    action = "<cmd>DapContinue<cr>";
    options.desc = "Debug start";
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
  {
    mode = "n";
    key = "<leader>dui";
    action = "<cmd>DapUiToggle<cr>";
    options.desc = "DAP UI";
  }

  # ---------- text objects ----------
  {
    mode = "v";
    key = "J";
    action = ":m '>+1<CR>gv=gv";
    options.desc = "Move line down";
  }
  {
    mode = "v";
    key = "K";
    action = ":m '<-2<CR>gv=gv";
    options.desc = "Move line up";
  }
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
  # ---------- todo comments ----------
  {
    mode = "n";
    key = "<leader>ft";
    action = "<cmd>TodoTelescope<cr>";
    options.desc = "Find TODOs";
  }
]
