{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # Build tools required for installing/compiling plugins (e.g. Telescope fzf-native)
      gcc
      gnumake
      unzip
      wl-clipboard
      ripgrep
      fd

      # Language Servers (LSP)
      nodePackages.bash-language-server
      marksman
      pyright
      vscode-langservers-extracted # jsonls, cssls, html
      yaml-language-server
      lua-language-server
      nixd

      # Formatters & Linters
      nixfmt-rfc-style
      stylua
      selene
      shfmt
      nodePackages.prettier

      isort
      black
      taplo
    ];
  };
}
