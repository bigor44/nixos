{
  config,
  lib,
  ...
}: let
  cfg = config.bigor.services.ollama;
  serverIP = config.bigor.network.ips.minipc;
  domain = "ai.bigor.lan";
in {
  options.bigor.services.ollama = {
    enable = lib.mkEnableOption "Active la stack Ollama + Open WebUI (Sans Auth)";
  };

  config = lib.mkIf cfg.enable {
    services = {
      # ==========================================================================
      # 1. Ollama Service (Le "Cerveau")
      # ==========================================================================
      ollama = {
        enable = true;
        host = "127.0.0.1";
        # acceleration = "rocm";
      };

      # ==========================================================================
      # 2. Open WebUI (L'Interface)
      # ==========================================================================
      open-webui = {
        enable = true;
        port = 8080;
        environment = {
          # Désactive l'authentification (Accès libre sur le réseau local)
          WEBUI_AUTH = "False";

          # URL interne pour parler à Ollama
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";

          # Nom de l'instance
          WEBUI_NAME = "Bigor AI";
        };
      };

      # ==========================================================================
      # 3. Reverse Proxy (Caddy)
      # ==========================================================================
      # Expose le service sur le port 443 avec un certificat interne
      caddy.virtualHosts."${domain}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080
          tls internal
        '';
      };

      # ==========================================================================
      # 4. Enregistrement DNS (AdGuard Home)
      # ==========================================================================
      # Injecte la réécriture DNS directement dans la config AdGuard locale.
      # NOTE : Cela ne fonctionne que si AdGuard tourne sur la MÊME machine.
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
