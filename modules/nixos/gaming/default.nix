{
  config,
  lib,
  ...
}:
{
  # ============================================================================
  # File: modules/nixos/gaming/default.nix
  # Description: Gaming Optimization Module
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Enables Steam and GameMode optimizations for gaming performance
  #          when the desktop role is enabled.
  # ============================================================================

  config = lib.mkIf config.bigor.roles.desktop {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };
  };
}
