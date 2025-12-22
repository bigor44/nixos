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
    # Register Ollama in registry
    bigor.registry.services.ollama = {
      inherit (config.networking) hostName;
      port = 8080;
      domain = "ai.bigor.lan";
      reverseProxy = true;
      openFirewall = false;
      openFirewallUDP = false;
      proxyProtocol = "http";
    };

    services.ollama = {
      enable = true;
      host = "127.0.0.1";
      package = pkgs.ollama-rocm;
    };
  };
}
