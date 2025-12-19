# ============================================================================
# File: modules/home/nixvim/default.nix
# Description: Main entry point for the NixVim configuration.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
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
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
        yaml-language-server
        nixd # Nix

        # ======================================================================
        # Formatters & Linters
        # ======================================================================
        nixfmt-rfc-style # Nix
        shfmt # Shell
        prettier # Web (JSON/YAML/Markdown/etc)
        taplo # TOML
      ];
    };
  };
}
