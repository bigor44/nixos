{
  pkgs,
  osConfig,
  ...
}:
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
    ];
  };
  home.sessionVariables = {
    NIXOS_HOSTNAME = osConfig.networking.hostName;
    NIXOS_FLAKE_PATH = "/home/bigor/nixos";
  };
}
