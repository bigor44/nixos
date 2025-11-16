{pkgs, ...}: {
  networking.hostName = "grospc";
  desktop.enable = true;
  server.enable = false;
  adblocker.enable = true;
  nfs.client.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };
}
