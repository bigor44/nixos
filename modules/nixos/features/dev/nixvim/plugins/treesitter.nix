# Feature: nixvim-treesitter
# Purpose: Treesitter configuration for nixvim
{
  programs.nixvim.plugins = {
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
