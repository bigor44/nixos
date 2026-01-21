# Feature: nixvim-mini
# Purpose: Mini.nvim consolidated configuration
{
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      # AI
      ai = { };

      # Editing & Motion
      cursorword = { };
      indentscope = { };
      pairs = { };
      surround = { };
      comment = { };
      trailspace = { };

      # UI Elements
      statusline = { };
      tabline = { };

      # Highlights
      hipatterns = {
        highlighters = {
          hex_color = {
            __raw = "require('mini.hipatterns').gen_highlighter.hex_color()";
          };
          fixme = {
            pattern = "%f[%w]()FIXME()%f[%W]";
            group = "MiniHipatternsFixme";
          };
          hack = {
            pattern = "%f[%w]()HACK()%f[%W]";
            group = "MiniHipatternsHack";
          };
          todo = {
            pattern = "%f[%w]()TODO()%f[%W]";
            group = "MiniHipatternsTodo";
          };
          note = {
            pattern = "%f[%w]()NOTE()%f[%W]";
            group = "MiniHipatternsNote";
          };
        };
      };

      # Keybinding Hints (Mini.clue)
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
