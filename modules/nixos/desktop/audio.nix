{
  config,
  lib,
  ...
}:
lib.mkIf config.desktop.enable {
  # PipeWire is the modern audio server for Linux, replacing PulseAudio and JACK.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # PulseAudio compatibility layer
    wireplumber.enable = true; # Session manager
  };

  # RealtimeKit allows audio processes to acquire realtime scheduling priority.
  security.rtkit.enable = true;
}
