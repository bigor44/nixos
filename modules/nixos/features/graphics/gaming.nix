# Feature: graphics-gaming
# Purpose: Gaming optimizations (Steam, GameMode)
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.graphics.gaming;
in
{
  options.bigor.features.graphics.gaming.enable = lib.mkEnableOption "Gaming optimizations";

  config = lib.mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };
  };
}
