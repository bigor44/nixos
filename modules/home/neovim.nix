{ config, pkgs, ... }:
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
      yamlfmt
      isort
      black
      taplo
    ];
  };

  # Development Workflow Configuration
  # We symlink the configuration from the local repository to ~/.config/nvim.
  # This allows editing files in ~/nixos/dotfiles/nvim and seeing changes immediately
  # without rebuilding the entire Home Manager environment.
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/nvim";
}
