{pkgs, ...}: {
  imports = [./hardware-configuration.nix];
  role = "desktop";
  networking.hostName = "grospc";
  adblocker.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
  boot.kernelPackages = pkgs.linuxPackages_zen;
  services.thermald.enable = true;

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };
}
