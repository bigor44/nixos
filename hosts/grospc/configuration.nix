# Host: grospc
# Purpose: Desktop workstation with gaming; machine-specific settings (kernel, AMD GPU, LAN DNS)
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/shell.nix
    ../../modules/nixos/dev.nix
    ../../modules/nixos/nixvim.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix
  ];

  networking = {
    hostName = "grospc";
    # insertNameservers only re-applies on link up, so DHCPv6/RA updates dropped Pi-hole from resolv.conf
    networkmanager.dns = "none";
    # Pi-hole first, router as fallback; IPv4 only since Pi-hole's IPv6 addresses are SLAAC-dynamic
    nameservers = [
      "192.168.1.10"
      "192.168.1.1"
    ];
    # glibc waits 5 s per query before falling back; Pi-hole answers in ms when it is up
    resolvconf.extraOptions = [ "timeout:1" ];
  };

  # Release this machine was installed with; governs stateful data formats, not package versions. Do not bump.
  system.stateVersion = "26.05";

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # --- AMD GPU ---
  # Unlocks the voltage/clock tables the driver hides by default, needed for LACT's undervolt
  hardware.amdgpu.overdrive.enable = true;
  # GPU fan curves, power limit and undervolt (LACT GUI)
  services.lact.enable = true;
  environment.systemPackages = [ pkgs.amdgpu_top ];
}
