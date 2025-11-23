{
  programs.nixvim.plugins = {
    # --- Git ---
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
        signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
          untracked.text = "┆";
        };
      };
    };

    # --- Terminal ---
    toggleterm = {
      enable = true;
      settings = {
        size = 20;
        open_mapping = "[[<C-\\>]]";
        direction = "float";
        float_opts.border = "curved";
      };
    };

    # --- Editing Utils ---
    nvim-surround.enable = true;
    nvim-autopairs.enable = true;
    comment.enable = true;

    todo-comments = {
      enable = true;
      settings.signs = true;
    };

    which-key = {
      enable = true;
      settings = {
        delay = 500;
        spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>d";
            group = "Debug";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "Workspace";
          }
        ];
      };
    };
  };
}
