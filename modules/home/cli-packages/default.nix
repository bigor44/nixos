{
  config,
  lib,
  pkgs,
  ...
}:
# ============================================================================
# CLI Tools & Packages
# ============================================================================
# Installs a suite of modern command-line utilities and code quality tools
# (formatters, linters) for development.
# ============================================================================
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

      # Code Quality Tools
      statix
      deadnix
      treefmt
      nodePackages.prettier
      alejandra

      stylua
      shfmt
      isort
      black
      taplo
      # Network Utilities
      dig

      # Monitoring & Performance
      btop
      sysstat
      inxi
      pciutils
      usbutils
      mesa-demos
      lm_sensors
      fastfetch
    ];
  };
}
