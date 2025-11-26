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

      # Formatters
      nixfmt-rfc-style
      stylua
      shfmt
      jq
      nodePackages.prettier

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
      black
      isort
      python3
    ];
  };
}
