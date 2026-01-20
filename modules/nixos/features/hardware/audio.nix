# Feature: hardware-audio
# Purpose: PipeWire audio stack with ALSA and PulseAudio compatibility
{
  lib,
  config,
  ...
}:
let
  cfg = config.bigor.features.hardware.audio;
in
{
  options.bigor.features.hardware.audio.enable = lib.mkEnableOption "Audio stack (Pipewire)";

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;
  };
}
