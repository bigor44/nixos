# Feature: services-samba
# Purpose: Samba file sharing
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.services.samba;
in
{
  options.bigor.features.services.samba = {
    enable = lib.mkEnableOption "Samba file sharing";
  };

  config = lib.mkIf cfg.enable {
    # Ensure the directory exists with permissions for guest access
    systemd.tmpfiles.rules = [
      "d /mnt/storage 0777 nobody nogroup -"
    ];

    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          # public share without login
          "map to guest" = "bad user";
          "guest account" = "nobody";
        };
        "share" = {
          "path" = "/mnt/storage";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "nobody";
          "force group" = "nogroup";
        };
      };
    };

    # Web Service Discovery Daemon (makes host visible in Windows Network)
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };
}
