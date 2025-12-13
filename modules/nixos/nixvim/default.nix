{pkgs, ...}: {
  # ============================================================================
  # NixVim Configuration (Neovim)
  # ============================================================================
  # Configures Neovim using the NixVim wrapper.
  # - Sets it as the default system editor.
  # - Installs necessary build tools and Language Servers (LSP).
  # - Integrates Lua configuration for overrides.
  # ============================================================================
  imports = [
    ./opts.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # For things not easily covered by modules (like vim.notify override)
    extraConfigLua = ''
      -- Override notify with mini.notify
      vim.notify = require("mini.notify").make_notify()
    '';

    extraPackages = with pkgs; [
      # Build tools
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
      nil

      # Formatters & Linters
      alejandra
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
