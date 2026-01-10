# Module: nfs
# Purpose: Network file sharing (server exports, client mounts, local storage)
#
# Note: This service is typically configured by bigor.policies.storage
# The storage policy sets server/client/localStorage options based on the storage mode
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    ;
  cfg = config.bigor.services.nfs;
  networkCfg = config.bigor.network;
  inherit (networkCfg) mainInterface;
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

      hostname = config.networking.hostName;

      # Check if /mnt/storage is mounted (either via localStorage or externally)
      hasStorageMounted =
        config.fileSystems ? "/mnt/storage" && config.fileSystems."/mnt/storage".device != "none";
    in
    mkMerge [
      # Safety assertions when service is used directly (bypassing policy layer)
      # Note: More comprehensive validation exists in bigor.policies.storage
      {
        assertions = [
          {
            assertion = cfg.server -> networkCfg.hosts.${hostname}.ip != null;
            message = "NFS server requires a static IP for ${hostname}. Consider using bigor.policies.storage.mode = \"nfs-server\" instead.";
          }
          {
            assertion = cfg.server -> hasStorageMounted;
            message = "NFS server requires /mnt/storage to be mounted. Enable localStorage or use bigor.policies.storage.";
          }
          {
            assertion = cfg.client -> networkCfg.hosts.${hostname}.ip != null;
            message = "NFS client requires a static IP for ${hostname}. Consider using bigor.policies.storage.mode = \"nfs-client\" instead.";
          }
          {
            assertion = !(cfg.client && cfg.localStorage.enable);
            message = "Cannot enable both NFS client and localStorage for /mnt/storage (conflicting mounts).";
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
          device = "${config.bigor.network.hosts.minipc.ip}:/mnt/storage";
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
