{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.services.nfs;
  inherit (config.bigor.network) ips;
in
{
  # ============================================================================
  # File: modules/nixos/services/nfs/default.nix
  # Description: NFS File Sharing Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures NFS server (exporting shares) and NFS client (mounting
  #          shares) based on enabled feature flags.
  # ============================================================================

  config = lib.mkMerge [
    # ==========================================================================
    # Server Configuration (minipc)
    # ==========================================================================
    # Exports the /mnt/storage directory to the local network.
    (lib.mkIf cfg.server {
      services.nfs.server = {
        enable = true;
        # Export options:
        # rw: Read-write access
        # sync: Reply only after data is committed to disk
        # no_subtree_check: Faster but less secure file checking
        # all_squash: Map all requests to anonymous user
        # anonuid/anongid: Map anonymous user to local user 'bigor' (1000/100)
        exports = ''
          /mnt/storage 192.168.1.0/24(rw,sync,no_subtree_check,secure,all_squash,anonuid=1000,anongid=100)
        '';
      };
      networking.firewall = {
        allowedTCPPorts = [
          111
          2049
        ];
        allowedUDPPorts = [
          111
          2049
        ];
      };
    })

    # ==========================================================================
    # Client Configuration (grospc)
    # ==========================================================================
    (lib.mkIf cfg.client {
      fileSystems."/mnt/storage" = {
        device = "${ips.minipc}:/mnt/storage";
        fsType = "nfs";
        # x-systemd.automount: Mounts on demand (access) rather than boot
        # noauto: Don't mount automatically at boot (handled by automount)
        options = [
          "x-systemd.automount"
          "noauto"
          "nfsvers=4.2"
          "timeo=14"
          "retrans=2"
        ];
      };
    })
  ];
}
