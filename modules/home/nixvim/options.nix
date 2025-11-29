{
  programs.nixvim = {
    opts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 300;
      undofile = true;
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
      mouse = "a";
      spelllang = [
        "en"
        "fr"
      ];
    };

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    autoCmd = [
      {
        event = [ "TextYankPost" ];
        pattern = [ "*" ];
        group = "HighlightYank";
        callback = {
          __raw = "function() vim.highlight.on_yank({ timeout = 250 }) end";
        };
      }
      {
        event = [ "BufEnter" ];
        pattern = [ "*" ];
        callback = {
          __raw = "function() vim.opt_local.formatoptions:remove({ 'r', 'o' }) end";
        };
      }
    ];

    autoGroups = {
      HighlightYank = {
        clear = true;
      };
    };
  };
}
