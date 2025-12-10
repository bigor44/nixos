{lib, ...}: {
  # ============================================================================
  # Custom Options API
  # ============================================================================
  # This file defines the high-level feature flags (options) used to control
  # the system configuration. These options abstract away complex module
  # imports and settings, allowing for a cleaner host configuration.
  # ============================================================================

  options.bigor = {
    roles = {
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
    sshd.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the OpenSSH daemon with hardened security defaults (no root login, key-based auth only).";
    };

    # File Sharing
    nfs = {
      server = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configures the machine to act as an NFS host, exporting defined storage directories (e.g., /mnt/storage).";
      };
      client = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Configures the machine to mount remote NFS shares defined in the configuration.";
      };
    };

    # Network Configuration
    network = {
      mainInterface = lib.mkOption {
        type = lib.types.str;
        default = "enp2s0";
        description = "The name of the primary network interface to configure (e.g., for Wake-on-LAN or optimizations).";
      };
      ips = {
        grospc = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.11";
          description = "Static IP address reserved for the Desktop (grospc).";
        };
        minipc = lib.mkOption {
          type = lib.types.str;
          default = "192.168.1.10";
          description = "Static IP address reserved for the Server (minipc).";
        };
      };
    };
  };
}
