{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;
}
