{
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      cursorword = {};
      indentscope = {};
      pairs = {};
      surround = {};
      comment = {};
      trailspace = {};
      # Clue needs complex config
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
          {__raw = "require('mini.clue').gen_clues.builtin_completion()";}
          {__raw = "require('mini.clue').gen_clues.g()";}
          {__raw = "require('mini.clue').gen_clues.marks()";}
          {__raw = "require('mini.clue').gen_clues.registers()";}
          {__raw = "require('mini.clue').gen_clues.windows()";}
          {__raw = "require('mini.clue').gen_clues.z()";}
        ];
      };
    };
  };
}
