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

      # --- Window Navigation (Ctrl+hjkl) ---
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

      # --- Resize ---
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

      # --- Buffer Navigation (Shift+hl) ---
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

      # --- Indentation Mode Visual ---
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

      # --- Move Lines ---
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

      # --- Diagnostics (Trouble) ---
      # (Optional: You can also move this to plugins/lsp.nix)
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics";
      }
    ];
  };
}
