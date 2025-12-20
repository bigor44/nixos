# Feature: desktop.apps
# Purpose: System-wide desktop applications (Firefox)
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.desktop.apps;
in
{
  options.bigor.features.desktop.apps.enable = mkEnableOption "Desktop applications";

  config = mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}
