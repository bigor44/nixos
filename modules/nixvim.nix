{...}: {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    opts = {
      number = true;
      mouse = "a";
      relativenumber = true;
      shiftwidth = 2;
    };
    colorschemes = {
      tokyonight = {
        enable = true;
        settings = {
          style = "night";
        };
      };
    };
    plugins = {
      lualine.enable = true;
      guess-indent = {
        enable = true;
      };
      lsp = {
        enable = true;
        servers.nixd.enable = true;
      };
    };
  };
}
