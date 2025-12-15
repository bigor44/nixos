{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.desktop.cosmic;
in
{
  # ============================================================================
  # File: modules/nixos/desktop/cosmic/default.nix
  # Description: Desktop Environment Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Sets up the graphical environment (COSMIC), audio (Pipewire),
  #          bluetooth, and essential desktop applications.
  # ============================================================================

  options.bigor.desktop.cosmic = {
    enable = mkEnableOption "Enable the Desktop Environment configuration (COSMIC, Pipewire, Bluetooth, etc.)";
  };

  config = mkIf cfg.enable {

    # ==========================================================================
    # Audio Subsystem (Pipewire)
    # ==========================================================================
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # RTKit is required for PipeWire to acquire realtime scheduling priority.
    # This helps reduce audio latency and prevents dropouts.
    security.rtkit.enable = true;

    # ==========================================================================
    # Bluetooth
    # ==========================================================================
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Enable dual mode (BREDR/LE)
          ControllerMode = "dual";
          # Enable experimental features (often needed for battery reporting)
          Experimental = true;
          # Improves connection speed for paired devices
          FastConnectable = true;
        };
        Policy.AutoEnable = true;
      };
    };

    # ==========================================================================
    # Desktop Base Packages
    # ==========================================================================
    programs = {
      firefox.enable = true;
    };

    boot = {
      # Reduce console log level to hide non-critical kernel messages during boot.
      consoleLogLevel = 3;
      # "quiet" parameter to suppress most boot messages for a cleaner boot experience.
      kernelParams = [ "quiet" ];
    };

    # ==========================================================================
    # Network Manager
    # ==========================================================================
    # Enable NetworkManager for easier network configuration via GUI.
    networking.networkmanager.enable = true;

    # ==========================================================================
    # Desktop Environment: COSMIC
    # ==========================================================================
    services = {
      displayManager = {
        cosmic-greeter.enable = true;
      };
      desktopManager = {
        cosmic.enable = true;
      };
    };
  };
}
