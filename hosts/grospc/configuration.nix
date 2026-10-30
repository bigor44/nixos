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
    ../../modules/nixos/home.nix
  ];
  networking = {
    hostName = "grospc";
    networkmanager.dns = "none";
    nameservers = [
      "192.168.1.10"
      "192.168.1.1"
    ];
    resolvconf.extraOptions = [ "timeout:1" ];
  };
  system.stateVersion = "26.05";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.amdgpu.overdrive.enable = true;
  services.lact.enable = true;
  environment.systemPackages = [ pkgs.amdgpu_top ];
}
