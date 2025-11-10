{
  # Global options
  opts = {
    number = true;
    relativenumber = true;
    autoindent = true;
    expandtab = true;
    tabstop = 2;
    shiftwidth = 2;
    smartindent = true;
    mouse = "a";
    clipboard = "unnamedplus";
    ignorecase = true;
    smartcase = true;
    termguicolors = true;
    signcolumn = "yes";
    updatetime = 250;
    timeoutlen = 300;
    completeopt = "menu,menuone,noselect";
    undofile = true;
    cursorline = true;
  };

  # Global settings
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  # Additional vim options for spell checking
  extraConfigVim = ''
    set spell
    set spelllang=en,fr
  '';
}
