{...}: 

{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
        languages = {
          nix = {
            enable = true;
            extraDiagnostics.enable = true;
            format.enable = true; 
          };
        };
      };
    };
  };
}
