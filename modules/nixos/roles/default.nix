{ config, lib, ... }:
{
  # ============================================================================
  # File: modules/nixos/roles/default.nix
  # Description: System Roles Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Defines high-level system roles (Desktop, Homelab Master) and
  #          applies default feature flags for each role.
  # ============================================================================

  options.bigor.roles = {
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the full graphical desktop environment (COSMIC), audio subsystem (Pipewire), fonts, and GUI applications suitable for a workstation.";
    };
    homelab_master = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables headless server services, container orchestration tools (Docker/Podman), and infrastructure management utilities.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.bigor.roles.desktop {
      bigor = {
        desktop = {
          cosmic.enable = lib.mkDefault true;
          gaming.enable = lib.mkDefault true;
        };
      };
    })

    (lib.mkIf config.bigor.roles.homelab_master {
      bigor.services = {
        ssh.enable = lib.mkDefault true;
        tailscale.enable = lib.mkDefault true;
        caddy.enable = lib.mkDefault true;
        adguard.enable = lib.mkDefault true;
        ollama.enable = lib.mkDefault true;
        nfs.server = lib.mkDefault true;
      };
    })
  ];
}
