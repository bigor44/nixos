# ============================================================================
# File: /home/bigor/nixos/modules/nixos/profiles/homelab_master/default.nix
# Description: Configures the Homelab Master server profile.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.profiles.homelab-master;
in
{
  options.bigor.profiles.homelab-master = {
    enable = mkEnableOption "Homelab Master server profile";
  };

  config = mkIf cfg.enable {
    # Enable all the necessary services for a homelab master server.
    bigor.services = {
      ssh.enable = mkDefault true;
      tailscale.enable = mkDefault true;
      caddy.enable = mkDefault true;
      adguard.enable = mkDefault true;
      ollama.enable = mkDefault true;
      nfs.server = mkDefault true;

      # Monitoring stack for the homelab master.
      monitoring = {
        prometheus.enable = mkDefault true;
        grafana.enable = mkDefault true;
        alertmanager.enable = mkDefault true;
        node-exporter.enable = mkDefault true;
      };
    };
  };
}
