# ============================================================================
# File: modules/home/nixvim/autocmds.nix
# Description: Configures Neovim autocommands.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
_: {
  programs.nixvim = {
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
  };
}
