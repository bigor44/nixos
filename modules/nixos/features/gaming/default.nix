# ============================================================================
# File: modules/nixos/features/gaming/default.nix
# Description: Configures gaming-related features.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
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
