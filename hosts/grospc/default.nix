{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "grospc";

  system.role = "desktop";

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
  fileSystems."/mnt/storage" = {
    device = "192.168.1.10:/mnt/storage"; # IP du minipc
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ]; # Montage à la demande pour ne pas bloquer le boot
  };
}
