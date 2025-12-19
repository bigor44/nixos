# ============================================================================
# File: modules/nixos/features/audio/default.nix
# Description: Configures the audio stack.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ lib, config, ... }:
with lib;
let
  cfg = config.bigor.features.audio;
in
{
  options.bigor.features.audio = {
    enable = mkEnableOption "Enable audio stack (Pipewire)";
  };

  config = mkIf cfg.enable {
    # Enable the Pipewire audio server and its related services.
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true; # For compatibility with 32-bit applications
      pulse.enable = true; # For PulseAudio clients
      wireplumber.enable = true; # Session manager for Pipewire
    };

    # Enable the real-time kit for low-latency audio.
    security.rtkit.enable = true;
  };
}
