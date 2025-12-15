{ lib, ... }:
{
  # ============================================================================
  # File: modules/nixos/network/default.nix
  # Description: Network Configuration Options
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Defines network-related options such as interface names and
  #          static IP reservations.
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
}
