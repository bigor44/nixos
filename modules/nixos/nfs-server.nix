/*
  Title: NFS Server Configuration
  Description: Configures NFS server to share /mnt/storage
*/
{ config, lib, ... }:
lib.mkIf config.nfs.server.enable {
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/storage 192.168.1.1(rw,sync,no_subtree_check,no_root_squash)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 2049 ]; # NFS
    allowedUDPPorts = [ 2049 ];
  };
}
