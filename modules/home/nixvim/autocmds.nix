{
  # ============================================================================
  # File: modules/home/nixvim/autocmds.nix
  # Description: Neovim Autocommands
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Defines automated actions based on editor events (e.g., highlight on yank).
  # ============================================================================

  programs.nixvim = {
    autoGroups = {
      gemini_highlight_yank = {
        clear = true;
      };
    };

    autoCmd = [
      # Highlight text briefly when yanking (copying)
      {
        event = "TextYankPost";
        group = "gemini_highlight_yank";
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
