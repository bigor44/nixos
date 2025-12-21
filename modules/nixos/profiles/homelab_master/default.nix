# Profile: homelab-master
# Purpose: Server stack with monitoring, Caddy, DNS (Unbound+Blocky), Ollama, and NFS
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.profiles.homelab-master;
in
{
  options.bigor.profiles.homelab-master.enable = mkEnableOption "Homelab Master server profile";

  config = mkIf cfg.enable {
    bigor.services = {
      ssh.enable = mkDefault true;
      tailscale.enable = mkDefault true;
      caddy.enable = mkDefault true;

      # DNS Stack: Unbound (recursive resolver) + Blocky (filtering)
      unbound.enable = mkDefault true;
      blocky.enable = mkDefault true;

      ollama.enable = mkDefault true;
      nfs.server = mkDefault true;

      monitoring = {
        prometheus.enable = mkDefault true;
        grafana.enable = mkDefault true;
        alertmanager.enable = mkDefault true;
        node-exporter.enable = mkDefault true;
      };
    };
  };
}
