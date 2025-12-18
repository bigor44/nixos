# ============================================================================
# File: /home/bigor/nixos/modules/nixos/features/desktop/base/default.nix
# Description: Configures the COSMIC desktop environment.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.desktop.base;
in
{
  options.bigor.features.desktop.base = {
    enable = mkEnableOption "Enable desktop core components";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
