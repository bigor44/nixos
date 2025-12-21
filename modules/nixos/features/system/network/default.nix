# Feature: system.network
# Purpose: Network configuration options and static /etc/hosts entries
{ lib, config, ... }:
{
  options.bigor.network = {
    mainInterface = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Primary network interface name";
    };
    ips = {
      grospc = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.11";
        description = "Static IP for grospc desktop";
      };
      minipc = lib.mkOption {
        type = lib.types.str;
        default = "192.168.1.10";
        description = "Static IP for minipc server";
      };
    };
  };

  config = {
    networking.extraHosts = ''
      ${config.bigor.network.ips.minipc} minipc
      ${config.bigor.network.ips.grospc} grospc
    '';
  };
}
