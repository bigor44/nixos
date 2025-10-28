{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      catppuccin-nvim
    ];
    extraConfig = ''
      set number relativenumber
      set mouse=a
      colorscheme catppuccin
    '';
  };
}
