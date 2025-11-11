{ config, pkgs, ... }:

{
  fileSystems."/mnt/shared" = {
    device = "192.168.1.10:/mnt/storage";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" ];
  };
}
