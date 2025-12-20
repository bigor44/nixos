# Module: cli-packages
# Purpose: Essential CLI tools for development and system monitoring
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bigor.home.cli-packages;
in
{
  options.bigor.home.cli-packages.enable = mkEnableOption "CLI packages";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Modern CLI tools
      eza
      fd
      ripgrep
      jq
      lazygit

      # Code quality & development
      statix
      deadnix
      treefmt
      prettier
      nixfmt-rfc-style
      shfmt
      taplo

      # Network utilities
      dig

      # Monitoring & performance
      btop
      sysstat
      inxi
      pciutils
      usbutils
      mesa-demos
      lm_sensors
      fastfetch

      claude-code
    ];
  };
}
