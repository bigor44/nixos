# Feature: gaming
# Purpose: Gaming optimizations (Steam, GameMode)
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
  options.bigor.features.gaming.enable = mkEnableOption "Gaming optimizations";

  config = mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };
  };
}
