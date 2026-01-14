# Policy: storage
# Purpose: Strategic storage configuration (NFS server/client, local storage)
{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.bigor.platform.policies.storage;
  hostname = config.networking.hostName;
  networkCfg = config.bigor.network;
in
{
  options.bigor.platform.policies.storage = {
    mode = mkOption {
      type = types.enum [
        "nfs-server"
        "nfs-client"
        "local"
        "none"
      ];
      default = "none";
      description = ''
        Storage access strategy:
        - "nfs-server": Export local storage via NFS (requires static IP + device)
        - "nfs-client": Mount storage from minipc via NFS (requires static IP)
        - "local": Local storage mount, no network sharing (requires device, works with DHCP)
        - "none": No storage mount

        Note: Only NFS modes require static IP. "local" mode works with DHCP.
      '';
    };

    device = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Device path or UUID for local storage (required for nfs-server/local modes)";
      example = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
    };

    fsType = mkOption {
      type = types.str;
      default = "ext4";
      description = "Filesystem type for local storage";
    };

    computed = {
      shouldRunNfsServer = mkOption {
        type = types.bool;
        readOnly = true;
        default = cfg.mode == "nfs-server";
        description = "Whether this host should export storage via NFS";
      };

      shouldMountNfsClient = mkOption {
        type = types.bool;
        readOnly = true;
        default = cfg.mode == "nfs-client";
        description = "Whether this host should mount remote NFS storage";
      };

      localDevice = mkOption {
        type = types.nullOr types.str;
        readOnly = true;
        default =
          {
            nfs-server = cfg.device;
            nfs-client = null;
            local = cfg.device;
            none = null;
          }
          .${cfg.mode};
        description = "Local storage device to mount (null if none)";
      };
    };
  };

  config = {
    # Strategic assertions: validate prerequisites for storage modes
    # This is the authoritative validation layer for storage configuration
    # Note: "local" mode does NOT require static IP (can use DHCP)
    # Only NFS modes require static IP for reliable network mounting
    assertions = [
      {
        assertion = cfg.mode == "nfs-server" -> networkCfg.hosts.${hostname}.ip != null;
        message = "Storage policy 'nfs-server' requires a static IP for ${hostname}";
      }
      {
        assertion = cfg.mode == "nfs-client" -> networkCfg.hosts.${hostname}.ip != null;
        message = "Storage policy 'nfs-client' requires a static IP for ${hostname}";
      }
      {
        assertion = (cfg.mode == "nfs-server" || cfg.mode == "local") -> cfg.device != null;
        message = "Storage policy '${cfg.mode}' requires storage.device to be set";
      }
      {
        assertion = !(cfg.mode == "nfs-client" && cfg.device != null);
        message = "Storage policy 'nfs-client' should not have local device (conflicts with remote mount)";
      }
    ];

    # Auto-configure NFS service based on policy
    bigor.capabilities.nfs-server.enable = mkIf cfg.computed.shouldRunNfsServer true;
    bigor.capabilities.nfs-client.enable = mkIf cfg.computed.shouldMountNfsClient true;

    # Local storage mount (for nfs-server or local modes)
    fileSystems."/mnt/storage" = mkIf (cfg.computed.localDevice != null) {
      device = cfg.computed.localDevice;
      inherit (cfg) fsType;
    };
  };
}
