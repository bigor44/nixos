# ============================================================================
# File: systems/x86_64-linux/minidesk/default.nix
# Description: Host-specific configuration for the "minidesk" workstation.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, pkgs, ... }:
{
  imports = [ ../minipc/hardware-configuration.nix ];

  # Don't mount /mnt/storage in travel mode (disk not present)
  fileSystems."/mnt/storage" = lib.mkForce {
    device = "none";
    fsType = "none";
    options = [ "noauto" ];
  };

  networking.hostName = "minidesk";
  system.stateVersion = "25.05";

  # ============================================================================
  # Kernel & Power Management
  # ============================================================================
  # Enable AMD P-State EPP (Replace ACPI CPUFreq)
  # "active" enables the guided mode for effective governor management.
  boot.kernelParams = [ "amd_pstate=active" ];

  # Zen kernel provides better desktop responsiveness and fsync patches.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ============================================================================
  # Custom Profile & Feature Flags
  # ============================================================================
  # - Workstation profile for a full desktop experience.
  # - Connects to NFS storage (bigor.services.nfs.client)
  # - Network Configuration (bigor.network.mainInterface)
  bigor = {
    profiles.workstation.enable = true;
    services = {
      ssh.enable = true;
    };
    network.mainInterface = "enp2s0";
  };
}
