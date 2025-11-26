{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      # Language Servers
      lua-language-server
      nixd
      bash-language-server
      marksman
      nodePackages.vscode-langservers-extracted # JSON/YAML

      # Build tools & utilities
      ripgrep
      fd
      gnumake
      gcc
      gzip
      nodejs
      tree-sitter
      wl-clipboard

      # Python
      pyright
      python3
    ];
  };
}
