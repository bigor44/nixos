{
  config,
  lib,
  ...
}:
lib.mkIf config.roles.homelab_master {
  services = {
    caddy.virtualHosts."glances.bigor.lan" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:61208
        tls internal
      '';
    };

    adguardhome.settings.filtering.rewrites = [
      {
        domain = "glances.bigor.lan";
        answer = config.myNetwork.ips.minipc;
        enabled = true;
      }
    ];

    glances = {
      enable = true;
      openFirewall = false;
    };
  };
}
