/*
Title: Audio Configuration
Description: Configures the audio system, disabling PulseAudio and enabling PipeWire.
*/
{
  lib,
  config,
  ...
}:
lib.mkIf config.desktop.enable {
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # jack.enable = true;
  };
}
