# modules/nixos/homer.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.homer;

  # Very small starter config – users can override via services.homer.configYaml
  defaultConfig = pkgs.writeText "homer-config.yml" ''
    ---
    title: "Homer – ${config.networking.hostName}"
    subtitle: "Homelab dashboard"
    logo: "assets/logo.png"
    header: true
    footer: '<p>Built with ❤️ on NixOS</p>'
    theme: default
    colors: {}
    message: ""
    links:
      - name: "NixOS Wiki"
        icon: "fab fa-wikipedia-w"
        url: "https://nixos.wiki"
        target: "_blank"
    services:
      - name: "AdGuard Home"
        icon: "fas fa-shield-alt"
        subtitle: "DNS sink-hole"
        tag: "infra"
        url: "http://${config.networking.hostName}:3003"
        type: "Ping"
  '';

in
{
  options.services.homer = {
    enable = mkEnableOption "Homer static dashboard";

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "TCP port the Homer web-server listens on.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open the firewall for the Homer port.";
    };

    configYaml = mkOption {
      type = types.path;
      default = defaultConfig;
      description = ''
        Path to the Homer config.yml file.
        You can provide your own with
          services.homer.configYaml = ./my-homer-config.yml;
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/homer";
      description = "Directory where Homer assets and config are served from.";
    };
  };

  config = mkIf cfg.enable {
    # 1. Install the dashboard generator
    environment.systemPackages = [ pkgs.homer ];

    # 2. Create the data directory with the chosen config.yml
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 homer homer -"
      "L+ ${cfg.dataDir}/config.yml - - - - ${cfg.configYaml}"
      "L+ ${cfg.dataDir}/assets - - - - ${pkgs.homer}/share/homer/assets"
      "L+ ${cfg.dataDir}/dist - - - - ${pkgs.homer}/share/homer/dist"
      "L+ ${cfg.dataDir}/index.html - - - - ${pkgs.homer}/share/homer/index.html"
    ];

    # 3. Simple user for the service
    users.users.homer = {
      isSystemUser = true;
      group = "homer";
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.homer = {};

    # 4. Lightweight static-file server (darkhttpd)
    services.darkhttpd = {
      homer = {
        enable = true;
        root = cfg.dataDir;
        port = cfg.port;
        user = "homer";
        group = "homer";
      };
    };

    # 5. Firewall
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
