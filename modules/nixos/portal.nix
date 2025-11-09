/*
Title: Service Portal Configuration
Description: Hosts a web portal that links to all configured services.
*/
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.portal;

  # HTML template for the portal
  portalHtml = pkgs.writeText "portal.html" ''
    <!DOCTYPE html>
    <html lang="fr">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Portail de Services - ${config.networking.hostName}</title>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }

        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 20px;
        }

        .container {
          max-width: 1200px;
          width: 100%;
        }

        .header {
          text-align: center;
          margin-bottom: 40px;
          color: white;
        }

        .header h1 {
          font-size: 2.5rem;
          margin-bottom: 10px;
          text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .header p {
          font-size: 1.1rem;
          opacity: 0.9;
        }

        .services-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
          gap: 20px;
          margin-bottom: 40px;
        }

        .service-card {
          background: white;
          border-radius: 12px;
          padding: 30px;
          box-shadow: 0 10px 30px rgba(0,0,0,0.2);
          transition: transform 0.3s ease, box-shadow 0.3s ease;
          text-decoration: none;
          color: inherit;
          display: block;
        }

        .service-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }

        .service-icon {
          font-size: 3rem;
          margin-bottom: 15px;
        }

        .service-name {
          font-size: 1.4rem;
          font-weight: 600;
          margin-bottom: 8px;
          color: #333;
        }

        .service-description {
          font-size: 0.9rem;
          color: #666;
          margin-bottom: 12px;
        }

        .service-url {
          font-size: 0.85rem;
          color: #667eea;
          word-break: break-all;
        }

        .footer {
          text-align: center;
          color: white;
          opacity: 0.8;
          font-size: 0.9rem;
        }

        @media (max-width: 768px) {
          .header h1 {
            font-size: 2rem;
          }

          .services-grid {
            grid-template-columns: 1fr;
          }
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>🏠 Portail de Services</h1>
          <p>Bienvenue sur ${config.networking.hostName}</p>
        </div>

        <div class="services-grid">
          ${lib.optionalString config.adblocker.enable ''
      <a href="http://${config.networking.hostName}.lan:3003" class="service-card">
        <div class="service-icon">🛡️</div>
        <div class="service-name">AdGuard Home</div>
        <div class="service-description">Blocage de publicités et filtrage DNS</div>
        <div class="service-url">:3003</div>
      </a>
    ''}

          ${lib.optionalString config.llm.enable ''
      <a href="http://${config.networking.hostName}.lan:${toString config.services.open-webui.port}" class="service-card">
        <div class="service-icon">🤖</div>
        <div class="service-name">Open WebUI</div>
        <div class="service-description">Interface pour modèles de langage (Ollama)</div>
        <div class="service-url">:${toString config.services.open-webui.port}</div>
      </a>
    ''}

          ${lib.optionalString config.server.enable ''
      <a href="http://${config.networking.hostName}.lan:${toString config.services.grafana.settings.server.http_port}" class="service-card">
        <div class="service-icon">📊</div>
        <div class="service-name">Grafana</div>
        <div class="service-description">Tableaux de bord et monitoring système</div>
        <div class="service-url">:${toString config.services.grafana.settings.server.http_port}</div>
      </a>

      <a href="http://${config.networking.hostName}.lan:9090" class="service-card">
        <div class="service-icon">🔍</div>
        <div class="service-name">Prometheus</div>
        <div class="service-description">Collecte de métriques et alertes</div>
        <div class="service-url">:9090</div>
      </a>
    ''}
        </div>

        <div class="footer">
          <p>NixOS ${config.system.stateVersion} • ${config.networking.hostName}</p>
        </div>
      </div>
    </body>
    </html>
  '';
in {
  options.portal = {
    enable = lib.mkEnableOption "Enable service portal";

    port = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "Port on which the portal will be served";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;

      virtualHosts."${config.networking.hostName}.lan" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = cfg.port;
          }
        ];

        locations."/" = {
          root = pkgs.runCommand "portal-root" {} ''
            mkdir -p $out
            cp ${portalHtml} $out/index.html
          '';
          index = "index.html";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [cfg.port];
  };
}
