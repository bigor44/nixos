# Module: dev-tools
# Purpose: Development and code quality tools
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.home.dev-tools;
in
{
  options.bigor.home.dev-tools.enable = lib.mkEnableOption "Development tools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Code quality & development
      nix-health
      statix
      deadnix
      treefmt
      prettier
      nixfmt
      shfmt
      taplo

      # Development tools
      lazygit
      gemini-cli
      claude-code
    ];
  };
}
