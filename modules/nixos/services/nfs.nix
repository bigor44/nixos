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
    in
    mkMerge [
      # Safety assertions: enforce using policy layer for proper validation
      # The policy layer handles all validation (static IP, device, coherence)
      {
        assertions = [
          {
            assertion = !cfg.server || config.bigor.policies.storage.computed.shouldRunNfsServer;
            message = "NFS server should be enabled via bigor.policies.storage.mode = \"nfs-server\" instead of bigor.services.nfs.server. This ensures proper static IP and storage validation.";
          }
          {
            assertion = !cfg.client || config.bigor.policies.storage.computed.shouldMountNfsClient;
            message = "NFS client should be enabled via bigor.policies.storage.mode = \"nfs-client\" instead of bigor.services.nfs.client. This ensures static IP validation.";
          }
          {
            assertion =
              !cfg.localStorage.enable || (config.bigor.policies.storage.computed.localDevice != null);
            message = "Local storage should be configured via bigor.policies.storage (mode = \"nfs-server\" or \"local\") instead of bigor.services.nfs.localStorage directly.";
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
