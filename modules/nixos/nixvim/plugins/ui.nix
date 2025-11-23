{
  programs.nixvim = {
    # --- Thème (Déplacé ici) ---
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        # Options courantes pour gruvbox
        transparent_mode = false; # Mettre à true pour la transparence
        contrast_dark = "hard"; # Options: "soft", "medium", "hard"
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
