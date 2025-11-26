{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # Language Servers
      lua-language-server
      nixd
      bash-language-server
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
    ];
  };
}
