# ============================================================================
# File: /home/bigor/nixos/modules/nixos/services/ollama/default.nix
# Description: Configures the Ollama service.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
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
