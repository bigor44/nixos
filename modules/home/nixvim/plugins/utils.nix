{
  # ============================================================================
  # File: modules/home/nixvim/plugins/utils.nix
  # Description: Utility Plugins Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures miscellaneous utilities powered by 'mini.nvim', including
  #          auto-pairs, surroundings, comments, and keybinding hints.
  # ============================================================================

  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      ai = { };
      cursorword = { };
      indentscope = { };
      pairs = { };
      surround = { };
      comment = { };
      trailspace = { };

      # ========================================================================
      # Mini.clue (Keybinding Hints)
      # ========================================================================
      clue = {
        triggers = [
          {
            mode = "n";
            keys = "<Leader>";
          }
          {
            mode = "x";
            keys = "<Leader>";
          }
          {
            mode = "i";
            keys = "<C-x>";
          }
          {
            mode = "n";
            keys = "g";
          }
          {
            mode = "x";
            keys = "g";
          }
          {
            mode = "n";
            keys = "'";
          }
          {
            mode = "n";
            keys = "`";
          }
          {
            mode = "x";
            keys = "'";
          }
          {
            mode = "x";
            keys = "`";
          }
          {
            mode = "n";
            keys = "\"";
          }
          {
            mode = "x";
            keys = "\"";
          }
          {
            mode = "i";
            keys = "<C-r>";
          }
          {
            mode = "c";
            keys = "<C-r>";
          }
          {
            mode = "n";
            keys = "<C-w>";
          }
          {
            mode = "n";
            keys = "z";
          }
          {
            mode = "x";
            keys = "z";
          }
        ];
        clues = [
          { __raw = "require('mini.clue').gen_clues.builtin_completion()"; }
          { __raw = "require('mini.clue').gen_clues.g()"; }
          { __raw = "require('mini.clue').gen_clues.marks()"; }
          { __raw = "require('mini.clue').gen_clues.registers()"; }
          { __raw = "require('mini.clue').gen_clues.windows()"; }
          { __raw = "require('mini.clue').gen_clues.z()"; }
        ];
      };
    };
  };
}
