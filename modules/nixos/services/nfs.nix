# Module: nfs
# Purpose: Network file sharing (server exports, client mounts, local storage)
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
    server = mkEnableOption "NFS server exporting /mnt/storage" // {
      description = ''
        Enable NFS server to export /mnt/storage to the local network.

        Note: This is typically configured via bigor.policies.storage.mode = "nfs-server",
        which handles validation (static IP, storage device) automatically.
      '';
    };

    client = mkEnableOption "NFS client mounting remote shares" // {
      description = ''
        Enable NFS client to mount /mnt/storage from minipc.

        Note: This is typically configured via bigor.policies.storage.mode = "nfs-client",
        which validates that the host has a static IP for reliable NFS access.
      '';
    };

    localStorage = {
      enable = mkEnableOption "local storage mount at /mnt/storage" // {
        description = ''
          Enable local storage mount at /mnt/storage.

          Note: This is typically configured via bigor.policies.storage (mode = "nfs-server" or "local"),
          which validates that a storage device is specified.
        '';
      };
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
      # Safety assertions: policy layer must authorize service activation
      {
        assertions = [
          {
            assertion = cfg.server -> config.bigor.policies.storage.computed.shouldRunNfsServer;
            message = "NFS server requires bigor.policies.storage.mode = \"nfs-server\" (validates prerequisites)";
          }
          {
            assertion = cfg.client -> config.bigor.policies.storage.computed.shouldMountNfsClient;
            message = "NFS client requires bigor.policies.storage.mode = \"nfs-client\" (validates static IP)";
          }
          {
            assertion = cfg.localStorage.enable -> (config.bigor.policies.storage.computed.localDevice != null);
            message = "Local storage requires bigor.policies.storage with mode = \"nfs-server\" or \"local\" (validates device)";
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
