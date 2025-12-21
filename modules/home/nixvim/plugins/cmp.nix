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
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<C-p>" = "cmp.mapping.select_prev_item()";
              "<Down>" = "cmp.mapping.select_next_item()";
              "<Up>" = "cmp.mapping.select_prev_item()";
            };

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
