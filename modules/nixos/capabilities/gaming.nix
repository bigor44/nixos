# Feature: gaming
# Purpose: Gaming optimizations (Steam, GameMode)
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.capabilities.gaming;
in
{
  options.bigor.capabilities.gaming.enable = mkEnableOption "Gaming optimizations";

  config = mkIf cfg.enable {
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };
  };
}
