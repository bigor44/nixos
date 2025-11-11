{ config, pkgs, ... }:

{
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /mnt/storage 192.168.1.0/24(rw,sync,no_subtree_check)
  '';
  networking.firewall.allowedTCPPortRanges = [
    { from = 111; to = 111; }
    { from = 2049; to = 2049; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 111; to = 111; }
    { from = 2049; to = 2049; }
  ];
  fileSystems."/mnt/storage" = {
    device = "/dev/sda";
    fsType = "ext4";
  };
}
