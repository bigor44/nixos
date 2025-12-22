# Module: nixvim
# Purpose: Neovim configuration with LSP, treesitter, and completion
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

  options.bigor.home.nixvim.enable = lib.mkEnableOption "NixVim configuration";

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
        nixfmt-rfc-style
        shfmt
        prettier
        taplo
      ];
    };
  };
}
