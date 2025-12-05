{ lib, ... }:
{
  options = {
    system.features = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Liste des fonctionnalités actives (ex: 'desktop', 'sshd', 'server').";
      example = [
        "desktop"
        "nfs-client"
      ];
    };

    # Infrastructure services
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    dashboard.enable = lib.mkEnableOption "Enable Homepage Dashboard";
    reverse_proxy.enable = lib.mkEnableOption "Enable Caddy Reverse Proxy";
    tailscale.enable = lib.mkEnableOption "Enable Tailscale VPN";
    vaultwarden.enable = lib.mkEnableOption "Enable Vaultwarden Password Manager";
    glances.enable = lib.mkEnableOption "Enable Glances System Monitor";
    binary_cache.enable = lib.mkEnableOption "Enable Binary Cache (nix-serve)";

    # Desktop features
    desktop.enable = lib.mkEnableOption "Enable COSMIC Desktop";
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
