# ============================================================================
# File: /home/bigor/nixos/modules/nixos/features/bluetooth/default.nix
# Description: Configures Bluetooth support.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.bluetooth;
in
{
  options.bigor.features.bluetooth = {
    enable = mkEnableOption "Enable Bluetooth support";
  };

  config = mkIf cfg.enable {
    # Enable and configure Bluetooth hardware support.
    hardware.bluetooth = {
      enable = true;
      # Automatically power on Bluetooth devices on system boot.
      powerOnBoot = true;
    };
  };
}
