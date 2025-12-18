{ lib, config, ... }:
{
  # ============================================================================
  # File: modules/nixos/features/system/network/default.nix
  # Description: Defines network-related options and static host entries.
  # Author: Bigor
  # Date: 2025-12-18
  # ============================================================================

  options.bigor.network = {
    mainInterface = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "The name of the primary network interface to configure (e.g., for Wake-on-LAN or optimizations).";
    };
    ips = {
      grospc = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.11";
        description = "Static IP address reserved for the Desktop (grospc).";
      };
      minipc = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.10";
        description = "Static IP address reserved for the Server (minipc).";
      };
    };
  };
  # Define static hostnames for local machines to ensure reliable resolution
  # without relying on external DNS.
  config = {
    networking.extraHosts = ''
      ${config.bigor.network.ips.minipc} minipc
      ${config.bigor.network.ips.grospc} grospc
    '';
  };
}
