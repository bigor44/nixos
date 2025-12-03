{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
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

  # --- Paquets de base Desktop ---
  programs = {
    firefox.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };
}
