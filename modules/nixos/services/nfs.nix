# Module: nfs
# Purpose: Network file sharing (server exports, client mounts, local storage)
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.nfs;
  hostname = config.networking.hostName;
  networkCfg = config.bigor.network;
  inherit (networkCfg) ips mainInterface;

  # Check if /mnt/storage is a real local filesystem (not NFS, not disabled)
  hasLocalStorage =
    config.fileSystems ? "/mnt/storage"
    && config.fileSystems."/mnt/storage".fsType != "nfs"
    && config.fileSystems."/mnt/storage".device != "none";
in
{
  options.bigor.services.nfs = {
    server = mkEnableOption "NFS server exporting /mnt/storage";
    client = mkEnableOption "NFS client mounting remote shares";

    localStorage = {
      enable = mkEnableOption "local storage mount at /mnt/storage";
      device = mkOption {
        type = types.str;
        description = "Device path or UUID for local storage (e.g., /dev/disk/by-uuid/...)";
        example = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
      fsType = mkOption {
        type = types.str;
        default = "ext4";
        description = "Filesystem type for local storage";
      };
    };
  };

  config =
    let
      # NFS export options: all requests mapped to bigor (1000:100) for security
      nfsOptions = "rw,sync,no_subtree_check,secure,all_squash,anonuid=1000,anongid=100";
    in
    mkMerge [
      # Assertions for coherence
      {
        assertions = [
          {
            assertion = cfg.client -> networkCfg.hosts.${hostname}.ip != null;
            message = "NFS client requires a static IP. Host '${hostname}' uses DHCP.";
          }
          {
            assertion = cfg.server -> hasLocalStorage;
            message = "NFS server requires /mnt/storage to be mounted from a local disk.";
          }
          {
            assertion = !(cfg.client && cfg.localStorage.enable);
            message = "Cannot enable both NFS client and localStorage for /mnt/storage.";
          }
        ];
      }

      # Local storage mount
      (mkIf cfg.localStorage.enable {
        fileSystems."/mnt/storage" = {
          inherit (cfg.localStorage) device fsType;
        };
      })

      (mkIf cfg.server {
        services.nfs.server = {
          enable = true;
          exports = ''
            /mnt/storage ${config.bigor.network.subnet}(${nfsOptions})
          '';
        };

        # Open NFS ports (RPC + NFS server)
        networking.firewall.interfaces.${mainInterface} = {
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

      (mkIf cfg.client {
        fileSystems."/mnt/storage" = {
          device = "${ips.minipc}:/mnt/storage";
          fsType = "nfs";
          # Automount on access, not at boot
          options = [
            "x-systemd.automount"
            "_netdev"
            "nofail"
            "noatime"
            "soft"
            "timeo=600"
            "retrans=5"
          ];
        };
      })
    ];
}
