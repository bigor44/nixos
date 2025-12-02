{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Set $EDITOR to nvim
    viAlias = true; # Alias vi to nvim
    vimAlias = true; # Alias vim to nvim

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
      yamlfmt
      isort
      black
      taplo
    ];
  };

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/nvim";
}
