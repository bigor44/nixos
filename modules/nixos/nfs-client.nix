{ config, lib, ... }:
lib.mkIf config.nfs.client.enable {
  # Ensure the mount point exists
  systemd.tmpfiles.rules = [ "d /mnt/share 0755 root root -" ];

  fileSystems."/mnt/share" = {
    device = "192.168.1.10:/mnt/storage";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };
}
