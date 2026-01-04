# Feature: desktop.base
# Purpose: Core desktop components (NetworkManager)
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.desktop.base;
in
{
  options.bigor.features.desktop.base.enable = mkEnableOption "Desktop core components";

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
