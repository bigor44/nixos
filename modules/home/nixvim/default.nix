{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.home.nixvim;
in
{
  # ============================================================================
  # File: modules/home/nixvim/default.nix
  # Description: Neovim Configuration (NixVim)
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Entry point for the modular Neovim configuration.
  #          Imports sub-modules (opts, keymaps, plugins) and installs external tools.
  # ============================================================================

  imports = [
    ./opts.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  options.bigor.home.nixvim = {
    enable = lib.mkEnableOption "Enable NixVim configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      extraPackages = with pkgs; [
        wl-clipboard
        gcc

        # ======================================================================
        # Language Servers (LSP)
        # ======================================================================
        nodePackages.bash-language-server
        marksman # Markdown
        pyright # Python
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
        yaml-language-server
        lua-language-server
        nixd # Nix

        # ======================================================================
        # Formatters & Linters
        # ======================================================================
        nixfmt-rfc-style # Nix
        stylua # Lua
        selene # Lua linter
        shfmt # Shell
        prettier # Web (JSON/YAML/Markdown/etc)
        isort # Python imports
        black # Python code
        taplo # TOML
      ];
    };
  };
}
