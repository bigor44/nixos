# Feature: audio
# Purpose: PipeWire audio stack with ALSA and PulseAudio compatibility
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.capabilities.audio;
in
{
  options.bigor.capabilities.audio.enable = mkEnableOption "Audio stack (Pipewire)";

  config = mkIf cfg.enable {
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
