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
  # ============================================================================
  # File: modules/nixos/services/ollama/default.nix
  # Description: Ollama AI Service Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Deploys the Ollama AI backend and exposes it via Caddy.
  #          Includes DNS registration in AdGuard Home.
  # ============================================================================

  options.bigor.services.ollama = {
    enable = mkEnableOption "Enable Ollama stack + Open WebUI (No Auth)";
  };

  config = mkIf cfg.enable {
    services = {
      # ==========================================================================
      # 1. Ollama Service (The "Brain")
      # ==========================================================================
      ollama = {
        enable = true;
        host = "127.0.0.1";
        package = pkgs.ollama-rocm;
      };
    };

    bigor.lib.exposedService.ollama = {
      port = 8080;
      domain = "ai.bigor.lan";
    };
  };
}
