# Feature: nixvim-editing
# Purpose: Editing plugins (Formatting, Treesitter, Undotree)
{
  programs.nixvim.plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          json = [ "prettier" ];
          jsonc = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          toml = [ "taplo" ];
        };
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
      };
    };

    undotree.enable = true;

    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings.max_lines = 3;
    };
  };
}
