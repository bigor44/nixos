# Home: nixvim-opts
# Purpose: Editor options and visual settings for nixvim
{
  programs.nixvim = {
    # ==========================================================================
    # Visuals & Colorscheme
    # ==========================================================================
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = false;
      };
    };

    # ==========================================================================
    # Global Variables
    # ==========================================================================
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    # ==========================================================================
    # Editor Options
    # ==========================================================================
    opts = {
      # UI
      number = true;
      relativenumber = true;
      termguicolors = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      mouse = "a";

      # Indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      # Search
      ignorecase = true;
      smartcase = true;

      # Performance & Behavior
      updatetime = 250;
      timeoutlen = 300;
      undofile = true;
      completeopt = "menu,menuone,noselect";

      # Spell Checking
      spelllang = [
        "en"
        "fr"
      ];
    };

    # ==========================================================================
    # Clipboard
    # ==========================================================================
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true; # Wayland clipboard support
    };
  };
}
