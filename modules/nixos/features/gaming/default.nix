{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.features.gaming;
in
{
  # ============================================================================
  # File: modules/nixos/features/gaming/default.nix
  # Description: Gaming Optimization Module
  # Author: Bigor
  # Date: 2025-12-18
  # Purpose: Enables Steam and GameMode optimizations for gaming performance.
  # ============================================================================

  options.bigor.features.gaming = {
    enable = mkEnableOption "Enable gaming optimizations (Steam, GameMode)";
  };

  config = mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };
  };
}
