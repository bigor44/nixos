# ============================================================================
# File: /home/bigor/nixos/modules/home/nixvim/plugins/cmp.nix
# Description: Configuration for nvim-cmp.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.home.nixvim;
in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        cmp = {
          enable = true;
          settings = {
            snippet.expand = "function(args) vim.fn[\"vsnip#anonymous\"](args.body) end";

            mapping = {
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-e>" = "cmp.mapping.abort()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
            };

            # CORRECTION ICI : sources doit être une liste de maps avec la clé 'name'
            sources = [
              { name = "nvim_lsp"; }
              { name = "vsnip"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
          };
        };

        # Make sure you have a snippet solution like vsnip enabled
        vsnip.enable = true;
      };

      extraPackages = with pkgs; [
        # To make nvim-cmp work with treesitter
        tree-sitter
      ];
    };
  };
}
