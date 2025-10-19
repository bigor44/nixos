{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      vim-nix
      gruvbox
      luasnip
      nvim-cmp
      cmp_luasnip
      cmp-nvim-lsp
      fidget-nvim
    ];
    extraConfig = ''
      set number relativenumber
      set mouse=a
      colorscheme gruvbox
    '';
  };
}
