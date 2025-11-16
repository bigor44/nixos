{pkgs, ...}: {
  networking.hostName = "grospc";
  desktop.enable = true;
  server.enable = false;
  adblocker.enable = true;
  nfs.client.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems."/steamlibrary".options = [
    "noatime"
    "nodiratime"
  ];
}
