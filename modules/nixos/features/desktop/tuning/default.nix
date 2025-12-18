# ============================================================================
# File: /home/bigor/nixos/modules/nixos/features/desktop/tuning/default.nix
# Description: Configures the COSMIC desktop environment.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.desktop.tuning;
in
{
  options.bigor.features.desktop.tuning = {
    enable = mkEnableOption "Enable Desktop tuning";
  };

  config = mkIf cfg.enable {
    # Kernel parameters to provide a quieter boot experience.
    boot = {
      kernelParams = [
        "quiet"
        "splash"
      ];
      plymouth = {
        enable = true;
        theme = "spinner";
      };
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
