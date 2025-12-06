# Host Configuration: grospc
# ------------------------------------------------------------------------------
# Role: Main Desktop Workstation
# Hardware: High-performance x86_64 (Zen Kernel)
# Key Features:
# - Gaming & Development focus (roles.desktop)
# - NFS Client for storage access
# - Performance tuning (amd_pstate, cpuFreqGovernor)
# ------------------------------------------------------------------------------
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "grospc";
  system.stateVersion = "25.05";

  # Enable AMD P-State EPP (Replace ACPI CPUFreq)
  # "active" enables the guided mode which allows the governor to work more effectively.
  boot.kernelParams = [ "amd_pstate=active" ];

  roles.desktop = true;
  nfs.client = true;
  sshd.enable = true;

  # Performance Tuning
  # Use the 'performance' governor for maximum responsiveness.
  powerManagement.cpuFreqGovernor = "performance";
  # Zen kernel provides better desktop responsiveness and fsync patches.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  myNetwork.mainInterface = "enp14s0";

  # Secondary Storage for Games
  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime" # Reduce write wear
      "nodiratime"
    ];
  };
}
