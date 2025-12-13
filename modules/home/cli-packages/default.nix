{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.bigor.home.cli-packages;
in {
  options.bigor.home.cli-packages = {
    enable = mkEnableOption "Enable user cli packages";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Modern CLI replacements
      eza
      fd
      ripgrep
      jq
      lazygit
      gemini-cli

      # Code Quality Tools
      treefmt
      nodePackages.prettier
      alejandra

      stylua
      shfmt
      isort
      black
      taplo
    ];
  };
}
