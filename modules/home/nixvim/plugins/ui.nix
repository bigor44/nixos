{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        integrations = {
          cmp = true;
          treesitter = true;
          gitsigns = true;
          snacks = true;
          noice = true;
        };
      };
    };

    plugins = {
      web-devicons.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add = {
              text = "│";
            };
            change = {
              text = "│";
            };
            delete = {
              text = "_";
            };
          };
        };
      };
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      comment.enable = true;
      colorizer = {
        enable = true;
        settings = {
          userDefaultOptions = {
            names = false;
            RGB = true;
            RRGGBB = true;
          };
        };
      };
      which-key.enable = true;
    };
  };
}
