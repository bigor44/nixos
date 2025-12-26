# System: grospc
# Purpose: Desktop workstation with gaming optimizations
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  # AMD P-State EPP active mode for better power management
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    profiles.workstation.enable = true;
    services.nfs.client = true;
    network.mainInterface = "enp14s0";

    # Use Blocky with Unbound on minipc as upstream
    services.blocky = {
      enable = true;
      upstreamMode = "unbound-lan";
      upstreamHost = "minipc";
    };
  };
}
