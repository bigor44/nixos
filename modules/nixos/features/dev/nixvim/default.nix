# Feature: dev-nixvim
# Purpose: Neovim configuration with LSP, treesitter, and completion
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.dev.nixvim;
in
{
  options.bigor.features.dev.nixvim.enable = lib.mkEnableOption "Neovim with LSP and plugins";

  imports = [
    ./plugins
    ./keymaps.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

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

      # ==========================================================================
      # Autocommands
      # ==========================================================================
      autoGroups = {
        bigor_highlight_yank = {
          clear = true;
        };
      };

      autoCmd = [
        # Highlight text briefly when yanking (copying)
        {
          event = "TextYankPost";
          group = "bigor_highlight_yank";
          callback = {
            __raw = "function() vim.highlight.on_yank({ timeout = 250 }) end";
          };
        }
        # Remove annoying format options (auto-commenting next line) on Enter
        {
          event = "BufEnter";
          pattern = "*";
          callback = {
            __raw = "function() vim.opt_local.formatoptions:remove({ 'r', 'o' }) end";
          };
        }
      ];

      extraPackages = with pkgs; [
        wl-clipboard
        gcc

        # Language servers
        nodePackages.bash-language-server
        marksman
        yaml-language-server
        nixd

        # Formatters & linters
        nixfmt
        shfmt
        prettier
        taplo
      ];
    };
  };
}
