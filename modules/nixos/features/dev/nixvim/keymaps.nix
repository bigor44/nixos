# Home: nixvim-keymaps
# Purpose: Keyboard mappings configuration for nixvim
{
  programs.nixvim.keymaps = [
    # ==========================================================================
    # Standard Operations
    # ==========================================================================
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlights";
    }
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>nohl<cr>";
      options.desc = "Clear search highlights (Alternative)";
    }

    # ==========================================================================
    # Window Navigation (Ctrl + hjkl)
    # ==========================================================================
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Focus left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Focus lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Focus upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Focus right window";
    }

    # ==========================================================================
    # Window Resize
    # ==========================================================================
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

    # ==========================================================================
    # Buffer Navigation
    # ==========================================================================
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

    # ==========================================================================
    # Editing Enhancements
    # ==========================================================================
    # Stay in visual mode after indenting
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Indent selection left";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Indent selection right";
    }
    # Move selected lines up/down
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move selection up";
    }

    # ==========================================================================
    # Plugin Specific
    # ==========================================================================
    # Undotree
    {
      mode = "n";
      key = "<leader>u";
      action = "<cmd>UndotreeToggle<cr>";
      options.desc = "Toggle Undotree";
    }

    # Trouble
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Toggle Diagnostics (Trouble)";
    }

    # Neo-tree
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Neotree toggle<cr>";
      options.desc = "Toggle Explorer";
    }

    # LazyGit
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options.desc = "LazyGit";
    }
  ];
}
