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
    system.role = lib.mkOption {
      type = lib.types.enum roleEnum;
      default = "server";
      description = "Définit le profil global de la machine (desktop, server, etc.)";
    };

    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    desktop.enable = lib.mkEnableOption "Enable COSMIC Desktop";
    sshd.enable = lib.mkEnableOption "Enable SSH Server";
    dashboard.enable = lib.mkEnableOption "Enable Homepage Dashboard";
    reverse_proxy.enable = lib.mkEnableOption "Enable Caddy Reverse Proxy";
    tailscale.enable = lib.mkEnableOption "Enable Tailscale VPN";
    vaultwarden.enable = lib.mkEnableOption "Enable Vaultwarden Password Manager";
    nfs = {
      server = lib.mkEnableOption "Enable NFS Server Share";
      client = lib.mkEnableOption "Enable NFS Client Mount";
    };
    myNetwork = {
      mainInterface = lib.mkOption {
        type = lib.types.str;
        default = "enp2s0";
        description = "Interface réseau principale";
      };
      ips = {
        grospc = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.11";
          description = "Adresse IP statique du Desktop (grospc)";
        };
        minipc = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.10";
          description = "Adresse IP statique du Serveur (minipc)";
        };
      };
    };
  };
}
