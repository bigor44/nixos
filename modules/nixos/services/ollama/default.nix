# Module: ollama
# Purpose: Local LLM inference with ROCm GPU acceleration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bigor.services.ollama;
in
{
  options.bigor.services.ollama.enable = mkEnableOption "Ollama LLM service";

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      host = "127.0.0.1";
      package = pkgs.ollama-rocm;
    };
  };
}
