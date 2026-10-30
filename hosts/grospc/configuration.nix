# Host: grospc
# Purpose: Host entry point; picks the shared modules and holds machine-only settings (LAN DNS, kernel, AMD GPU)
{ pkgs, ... }:
{
  # No auto-import: a module missing from this list is silently ignored
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/core.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/shell.nix
    ../../modules/nixos/dev.nix
    ../../modules/nixos/nixvim.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/home.nix
  ];
  networking = {
    hostName = "grospc";
    # Keep NetworkManager from rewriting resolv.conf with DHCP/RA servers that bypass Pi-hole
    networkmanager.dns = "none";
    # Pi-hole, then the router so name resolution survives the Pi-hole being down
    nameservers = [
      "192.168.1.10"
      "192.168.1.1"
    ];
    # Default 5 s timeout makes every lookup stall while the Pi-hole is unreachable
    resolvconf.extraOptions = [ "timeout:1" ];
  };
  # Install-time release, used for stateful data migrations; never bump it on upgrade
  system.stateVersion = "26.05";
  # Low-latency scheduler tuning for desktop and gaming workloads
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # Exposes the power/clock tables LACT needs to undervolt and overclock
  hardware.amdgpu.overdrive.enable = true;
  services.lact.enable = true;
  environment.systemPackages = [ pkgs.amdgpu_top ];
}
