{
  programs.nixvim = {
    keymaps = [
      # --- Standard Operations ---
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "<leader>h";
        action = "<cmd>nohl<cr>";
        options.desc = "Clear search highlight";
      }
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
        options.desc = "Height -";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Width -";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Width +";
      }
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

      # --- Plugin: Mini.files ---
      {
        mode = "n";
        key = "<leader>e";
        action = ''<cmd>lua if not require("mini.files").close() then require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end<CR>'';
        options.desc = "File Explorer (toggle)";
      }
      {
        mode = "n";
        key = "<leader>E";
        action = ''<cmd>lua require("mini.files").open(vim.loop.cwd(), true)<CR>'';
        options.desc = "File Explorer (cwd)";
      }

      # --- Plugin: Mini.pick ---
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Pick files<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Pick grep_live<CR>";
        options.desc = "Live Grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Pick buffers<CR>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Pick help<CR>";
        options.desc = "Help Tags";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Pick resume<CR>";
        options.desc = "Resume Last Pick";
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>Pick grep_live<CR>";
        options.desc = "Search in Project";
      }

      # --- Plugin: Mini.diff ---
      {
        mode = "n";
        key = "]h";
        action = ''<cmd>lua require("mini.diff").goto_hunk("next")<CR>'';
        options.desc = "Next Hunk";
      }
      {
        mode = "n";
        key = "[h";
        action = ''<cmd>lua require("mini.diff").goto_hunk("prev")<CR>'';
        options.desc = "Previous Hunk";
      }

      # --- Plugin: Snacks ---
      {
        mode = "n";
        key = "<leader>gg";
        action = ''<cmd>lua Snacks.lazygit()<CR>'';
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gf";
        action = ''<cmd>lua Snacks.lazygit.log_file()<CR>'';
        options.desc = "Lazygit Current File History";
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = ''<cmd>lua Snacks.lazygit.log()<CR>'';
        options.desc = "Lazygit Log (Cwd)";
      }
      {
        mode = "n";
        key = "<c-t>";
        action = ''<cmd>lua Snacks.terminal.toggle()<CR>'';
        options.desc = "Toggle Terminal";
      }
      {
        mode = "n";
        key = "<c-_>";
        action = ''<cmd>lua Snacks.terminal.toggle()<CR>'';
        options.desc = "Toggle Terminal";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ''<cmd>lua require("mini.bufremove").delete()<CR>'';
        options.desc = "Delete Buffer";
      }
      {
        mode = "n";
        key = "<leader>n";
        action = ''<cmd>lua Snacks.notifier.show_history()<CR>'';
        options.desc = "Notification History";
      }
      {
        mode = "n";
        key = "<leader>un";
        action = ''<cmd>lua Snacks.notifier.hide()<CR>'';
        options.desc = "Dismiss All Notifications";
      }

      # --- Plugin: Trouble ---
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics";
      }
    ];
  };
}
