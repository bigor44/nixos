# Profile: workstation
# Purpose: Desktop environment with COSMIC DE, audio, gaming, and monitoring
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.profiles.workstation;
in
{
  options.bigor.profiles.workstation.enable = mkEnableOption "Desktop workstation profile";

  config = mkIf cfg.enable {
    bigor.features = {
      audio.enable = mkDefault true;
      bluetooth.enable = mkDefault true;
      flatpak.enable = mkDefault true;
      fonts.enable = mkDefault true;
      gaming.enable = mkDefault true;
      desktop = {
        base.enable = mkDefault true;
        cosmic.enable = mkDefault true;
        apps.enable = mkDefault true;
      };
    };

    bigor.services = {
      blocky.enable = mkDefault true;
    };
  };
}
