{ config, lib, ... }:
{
  # ============================================================================
  # File: modules/nixos/roles/default.nix
  # Description: System Roles Configuration
  # Author: Bigor
  # Date: 2025-12-18
  # Purpose: Defines high-level system roles. The 'desktop' role has been
  #          refactored into the 'workstation' profile.
  # ============================================================================

  options.bigor.roles = {
    homelab_master = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables headless server services, container orchestration tools (Docker/Podman), and infrastructure management utilities.";
    };
  };

  config = lib.mkMerge [
    # Configuration for the 'homelab_master' role.
    (lib.mkIf config.bigor.roles.homelab_master {
      bigor.services = {
        ssh.enable = lib.mkDefault true;
        tailscale.enable = lib.mkDefault true;
        caddy.enable = lib.mkDefault true;
        adguard.enable = lib.mkDefault true;
        ollama.enable = lib.mkDefault true;
        nfs.server = lib.mkDefault true;

        # Monitoring stack for the homelab master.
        monitoring = {
          prometheus.enable = lib.mkDefault true;
          grafana.enable = lib.mkDefault true;
          alertmanager.enable = lib.mkDefault true;
          node-exporter.enable = lib.mkDefault true;
        };
      };
    })
  ];
}
