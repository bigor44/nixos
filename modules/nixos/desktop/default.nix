{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # Desktop Base Configuration
  # ============================================================================
  # Foundation for the graphical environment.
  # - Audio: Pipewire (ALSA/PulseAudio/Wireplumber)
  # - Bluetooth: Enabled with high-quality settings
  # - Browsers: Firefox
  # ============================================================================
  config = lib.mkIf config.bigor.roles.desktop {
    # --- Audio (Pipewire & Realtime) ---
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

    # --- Bluetooth ---
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

    # --- Desktop Base Packages ---
    programs = {
      firefox.enable = true;
    };
    boot = {
      # Reduce console log level to hide non-critical kernel messages during boot.
      consoleLogLevel = 3;
      # "quiet" parameter to suppress most boot messages for a cleaner boot experience.
      kernelParams = ["quiet"];
    };

    # Network Manager
    # Enable NetworkManager for easier network configuration via GUI.
    networking.networkmanager.enable = true;

    # Desktop Environment: COSMIC
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
