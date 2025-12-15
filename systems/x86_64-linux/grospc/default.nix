{ pkgs, ... }:
{
  # ============================================================================
  # File: systems/x86_64-linux/grospc/default.nix
  # Description: Host-specific configuration for "grospc"
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Defines the main desktop workstation environment, including
  #          hardware-specific settings, gaming optimizations, and desktop roles.
  # ============================================================================

  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.05";

  # ============================================================================
  # Kernel & Power Management
  # ============================================================================
  # Enable AMD P-State EPP (Replace ACPI CPUFreq)
  # "active" enables the guided mode for effective governor management.
  boot.kernelParams = [ "amd_pstate=active" ];

  # Use the 'performance' governor for maximum responsiveness on the desktop.
  powerManagement.cpuFreqGovernor = "performance";

  # Zen kernel provides better desktop responsiveness and fsync patches.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ============================================================================
  # Custom Role & Feature Flags
  # ============================================================================
  # - Gaming & Development focus (bigor.roles.desktop)
  # - Connects to NFS storage (bigor.services.nfs.client)
  # - Network Configuration (bigor.network.mainInterface)
  bigor = {
    roles.desktop = true;
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
