{ pkgs, ... }:
{
  # ============================================================================
  # File: systems/x86_64-linux/grospc/default.nix
  # Description: Host-specific configuration for "grospc"
  # Author: Bigor
  # Date: 2025-12-18
  # Purpose: Defines the main desktop workstation environment, including
  #          hardware-specific settings, gaming optimizations, and desktop profile.
  # ============================================================================

  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

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
      nfs.client = true;
    };
    network.mainInterface = "enp14s0";
  };

  # ============================================================================
  # File Systems
  # ============================================================================
  # Secondary Storage for Games
  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime" # Reduce write wear and improve performance
      "nodiratime"
    ];
  };
}
