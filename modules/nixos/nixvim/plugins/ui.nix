{
  programs.nixvim = {
    # --- Thème (Déplacé ici) ---
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # Latte, Frappe, Macchiato, Mocha
        transparent_background = false; # Mettre à true si vous voulez la transparence
        integrations = {
          cmp = true;
          gitsigns = true;
          neotree = true;
          treesitter = true;
          telescope.enabled = true;
          which_key = true;
        };
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
