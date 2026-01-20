# Feature: dev-nixvim
# Purpose: Neovim configuration with LSP, treesitter, and completion
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.dev.nixvim;
in
{
  options.bigor.features.dev.nixvim.enable = lib.mkEnableOption "Neovim with LSP and plugins";

  imports = [
    ./opts.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins
  ];

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      extraPackages = with pkgs; [
        wl-clipboard
        gcc

        # Language servers
        nodePackages.bash-language-server
        marksman
        yaml-language-server
        nixd

        # Formatters & linters
        nixfmt
        shfmt
        prettier
        taplo
      ];
    };
  };
}
