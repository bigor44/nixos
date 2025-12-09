{
  programs.nixvim = {
    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "darker";
        transparent = false;
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    opts = {
      number = true;
      relativenumber = true;
      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      mouse = "a";
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 300;
      undofile = true;
      completeopt = "menu,menuone,noselect";
      spelllang = ["en" "fr"];
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
  };
}
