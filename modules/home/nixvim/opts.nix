# ============================================================================
# File: modules/home/nixvim/opts.nix
# Description: Configures Neovim options.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
_: {
  programs.nixvim = {
    # ==========================================================================
    # Visuals & Colorscheme
    # ==========================================================================
    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "darker";
        transparent = false;
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
      number = true; # Show line numbers
      relativenumber = true; # Relative line numbers
      termguicolors = true; # True color support
      signcolumn = "yes"; # Always show sign column
      cursorline = true; # Highlight current line
      scrolloff = 8; # Keep 8 lines above/below cursor
      mouse = "a"; # Enable mouse support

      # Indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true; # Use spaces instead of tabs
      smartindent = true;

      # Search
      ignorecase = true; # Ignore case in search patterns
      smartcase = true; # ...unless uppercase letters are used

      # Performance & Behavior
      updatetime = 250; # Faster completion/updates
      timeoutlen = 300; # Faster key sequence timeout
      undofile = true; # Persistent undo
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
