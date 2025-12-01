{ lib, ... }:
let
  roleEnum = [
    "desktop"
    "server"
    "hybrid"
  ];
in
{
  options = {
    # Defines the high-level purpose of the machine.
    # This triggers the activation of role-specific modules.
    system.role = lib.mkOption {
      type = lib.types.enum roleEnum;
      default = "server";
      description = "Defines the global system profile (desktop, server, etc.).";
    };

    # Infrastructure services
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    dashboard.enable = lib.mkEnableOption "Enable Homepage Dashboard";
    reverse_proxy.enable = lib.mkEnableOption "Enable Caddy Reverse Proxy";
    tailscale.enable = lib.mkEnableOption "Enable Tailscale VPN";
    vaultwarden.enable = lib.mkEnableOption "Enable Vaultwarden Password Manager";

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
