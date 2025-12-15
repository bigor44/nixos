{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.desktop.gaming;
in
{
  # ============================================================================
  # File: modules/nixos/desktop/gaming/default.nix
  # Description: Gaming Optimization Module
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Enables Steam and GameMode optimizations for gaming performance.
  # ============================================================================

  options.bigor.desktop.gaming = {
    enable = mkEnableOption "Enable gaming optimizations (Steam, GameMode)";
  };

  config = mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };
  };
}
