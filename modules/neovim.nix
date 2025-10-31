{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
      options = {
        autoindent = true;
        mouse = "a";
        shiftwidth = 2;
      };

      statusline = {
        lualine = {
          enable = true;
          theme = "catppuccin";
        };
      };

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        modes-nvim.enable = true;
        illuminate.enable = true;
        breadcrumbs = {
          enable = true;
          navbuddy.enable = true;
        };
      };

      visuals = {
        nvim-web-devicons.enable = true;
        indent-blankline.enable = true;
        highlight-undo.enable = true;
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;
        nix = {
          enable = true;
          lsp.server = "nixd";
          lsp.package = pkgs.nixd;
        };
        markdown.enable = true;
        bash.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
      };

      spellcheck.enable = true;
      filetree.neo-tree.enable = true;
      telescope.enable = true;
      treesitter.context.enable = true;
      autocomplete.nvim-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;
    };
  };
}
