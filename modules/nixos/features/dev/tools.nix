# Feature: dev-tools
# Purpose: Development and code quality tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.dev.tools;
in
{
  options.bigor.features.dev.tools.enable = lib.mkEnableOption "Development tools";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Code quality & development
      nix-health
      statix
      deadnix
      treefmt
      prettier
      nixfmt
      shfmt
      shellcheck
      taplo

      # Development tools
      gemini-cli
      codex
      neovim
      luaPackages.luacheck
      stylua
    ];
  };
}
