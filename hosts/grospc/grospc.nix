{pkgs, ...}: {
  networking.hostName = "grospc";
  desktop.enable = true;
  server.enable = false;
  adblocker.enable = true;
  nfs.client.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  fileSystems."/steamlibrary".options = [
    "noatime"
    "nodiratime"
  ];
}
