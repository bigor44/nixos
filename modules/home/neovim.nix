{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # Build dependencies
      gcc
      gnumake
      unzip
      wl-clipboard
      ripgrep
      fd

      # LSP Servers
      nodePackages.bash-language-server
      marksman
      pyright
      vscode-langservers-extracted # jsonls, cssls, html
      yaml-language-server
      lua-language-server
      nixd

      # Formatters
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

  # Link the configuration
  # Using mkOutOfStoreSymlink allows editing the config in dotfiles/nvim without rebuilding
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/nvim";
}
