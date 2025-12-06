{ lib, ... }:
{
  options = {
    roles = {
      desktop = lib.mkEnableOption "Enable Desktop features";
      homelab_master = lib.mkEnableOption "Enable Homelab Master features";
    };
    sshd.enable = lib.mkEnableOption "Enable SSH Server";

    # File Sharing
    nfs = {
      server = lib.mkEnableOption "Enable NFS Server Share";
      client = lib.mkEnableOption "Enable NFS Client Mount";
    };

    # Network Configuration
    myNetwork = {
      mainInterface = lib.mkOption {
        type = lib.types.str;
        default = "enp2s0";
        description = "Main network interface.";
      };
      ips = {
        grospc = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.11";
          description = "Static IP address for the Desktop (grospc).";
        };
        minipc = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.10";
          description = "Static IP address for the Server (minipc).";
        };
      };
    };
  };
}
