{ config, lib, ... }:
lib.mkIf config.nfs.server.enable {
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/storage 192.168.1.1(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 2049 ]; # NFS
    allowedUDPPorts = [ 2049 ];
  };

  # Ensure correct permissions on /mnt/storage
  systemd.tmpfiles.rules = [
    "d /mnt/storage 0755 bigor users -"
  ];
}
