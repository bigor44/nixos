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
    security.rtkit.enable = true;

    # --- Bluetooth ---
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          ControllerMode = "dual";
          Experimental = true;
          FastConnectable = true;
        };
        Policy.AutoEnable = true;
      };
    };

    # --- Desktop Base Packages ---
    programs = {
      firefox.enable = true;
    };
  };
}
