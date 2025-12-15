{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.services.ollama;
  serverIP = config.bigor.network.ips.minipc;
  domain = "ai.bigor.lan";
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
    enable = lib.mkEnableOption "Enable Ollama stack + Open WebUI (No Auth)";
  };

  config = lib.mkIf cfg.enable {
    services = {
      # ==========================================================================
      # 1. Ollama Service (The "Brain")
      # ==========================================================================
      ollama = {
        enable = true;
        host = "127.0.0.1";
        acceleration = "rocm";
      };

      # ==========================================================================
      # 2. Reverse Proxy (Caddy)
      # ==========================================================================
      # Expose the service on port 443 with an internal TLS certificate.
      caddy.virtualHosts."${domain}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080
          tls internal
        '';
      };

      # ==========================================================================
      # 3. DNS Registration (AdGuard Home)
      # ==========================================================================
      # Inject the DNS rewrite directly into the local AdGuard configuration.
      # NOTE: This only works if AdGuard is running on the SAME machine.
      adguardhome.settings.filtering.rewrites = [
        {
          inherit domain;
          answer = serverIP;
          enabled = true;
        }
      ];
    };
  };
}
