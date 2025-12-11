{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # Netdata Monitoring
  # ============================================================================
  # Real-time performance monitoring.
  # ============================================================================
  config = lib.mkIf config.bigor.roles.homelab_master {
    networking.firewall.allowedTCPPorts = [19999];

    services = {
      netdata = {
        enable = true;
      };

      # ==========================================================================
      # Host-Specific Integration (HomeLab Master)
      # ==========================================================================
      # If running on the master node (minipc), expose via Caddy and DNS.
      caddy.virtualHosts = {
        "netdata.bigor.lan" = {
          extraConfig = ''
            reverse_proxy :19999
            tls internal
          '';
        };
      };

      adguardhome.settings.filtering.rewrites = [
        {
          domain = "netdata.bigor.lan";
          answer = config.bigor.network.ips.minipc;
          enabled = true;
        }
      ];
    };
  };
}
