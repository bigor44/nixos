{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      # Langages et LSP
      lua-language-server
      nixd # Nix LSP
      nixfmt-rfc-style
      ripgrep
      gnumake
      fd
      gcc
      gzip
      nodejs
    ];
  };
}
