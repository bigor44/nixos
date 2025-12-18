{ lib, config, ... }:
# ============================================================================
# File: modules/nixos/features/bluetooth/default.nix
# Description: Manages Bluetooth support for NixOS.
# Author: Bigor
# Date: 2025-12-18
# Purpose: This module configures the system's Bluetooth hardware, enabling
#          it on boot.
# ============================================================================
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
