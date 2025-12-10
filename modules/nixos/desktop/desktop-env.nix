{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # COSMIC Desktop Environment
  # ============================================================================
  # Configures the System76 COSMIC desktop environment and display manager.
  # Also handles boot-time optimizations (quiet boot) and NetworkManager.
  # ============================================================================
  config = lib.mkIf config.bigor.roles.desktop {
    # Boot Configuration
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
