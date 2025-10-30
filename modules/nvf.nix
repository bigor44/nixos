{...}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "tokyonight";
        style = "storm";
      };
      lsp.enable = true;
      languages = {
        enableTreesitter = true;
        nix.enable = true;
        python.enable = true;
      };
      statusline.lualine.enable = true;
      telescope.enable = true;
    };
  };
}
