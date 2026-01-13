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
  cfg = config.bigor.capabilities.nfs;
  networkCfg = config.bigor.network;
  inherit (networkCfg) mainInterface ports;
in
{
  options.bigor.capabilities.nfs = {
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
      # Technical assertions for direct service configuration
      # Note: Strategic prerequisites (static IP, device availability) are validated by
      # bigor.policies.storage. Use the policy layer for safe, validated configuration.
      {
        assertions = [
          {
            assertion = cfg.server -> (cfg.localStorage.enable && cfg.localStorage.device != null);
            message = ''
              NFS server requires local storage to be configured.

              Recommended: Use bigor.policies.storage.mode = "nfs-server" for validated configuration.
              Manual: Enable bigor.services.nfs.localStorage with a device.
            '';
          }
          {
            assertion = cfg.localStorage.enable -> (cfg.localStorage.device != null);
            message = "Local storage requires a device to be specified in bigor.services.nfs.localStorage.device.";
          }
          {
            assertion = !(cfg.server && cfg.client);
            message = "Cannot enable both NFS server and client on the same host.";
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
            ports.nfs.rpc
            ports.nfs.server
          ];
          allowedUDPPorts = [
            ports.nfs.rpc
            ports.nfs.server
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
