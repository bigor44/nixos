{
  programs.nixvim = {
    # --- Thème (Déplacé ici) ---
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "moon";
        transparent = false;
      };
    };

    # --- Plugins UI ---
    plugins = {
      lualine.enable = true;
      noice.enable = true;
      web-devicons.enable = true;

      indent-blankline = {
        enable = true;
        settings.scope.enabled = true;
      };

      illuminate.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options.names = false;
      };
    };
  };
}
