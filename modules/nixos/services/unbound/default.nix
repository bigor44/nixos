# Module: unbound
# Purpose: High-performance recursive DNS resolver with DNSSEC validation
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.unbound;
in
{
  options.bigor.services.unbound = {
    enable = mkEnableOption "Unbound DNS resolver";

    listenOnLan = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Listen on LAN interface in addition to localhost.
        Allows other machines to use this Unbound instance as upstream.
        Firewall port automatically opened via registry.
      '';
    };
  };

  config = mkIf cfg.enable (
    let
      inherit (config.networking) hostName;

      # Get this host's IP from hosts registry
      hostConfig = config.bigor.network.hosts.${hostName};
      lanInterface = if cfg.listenOnLan then [ hostConfig.ip ] else [ ];

      # Build interface list (localhost + optional LAN)
      interfaces = [
        "127.0.0.1"
        "::1"
      ]
      ++ lanInterface;

      # Access control: localhost always allowed, LAN subnet if listening on LAN
      accessControl = [
        "127.0.0.0/8 allow"
        "::1 allow"
      ]
      ++ (lib.optionals cfg.listenOnLan [
        "192.168.1.0/24 allow" # bigor.lan subnet
      ]);
    in
    {
      # Register Unbound in registry
      bigor.registry.services.unbound-recursive = {
        inherit (config.networking) hostName;
        port = 5335;
        domain = null;
        reverseProxy = false;
        openFirewall = cfg.listenOnLan;
        openFirewallUDP = false;
        proxyProtocol = "http";
      };

      services.unbound = {
        enable = true;

        settings = {
          server = {
            # Listen on localhost (+ optional LAN interface)
            interface = interfaces;
            port = 5335; # Non-standard port to avoid conflicts

            # Performance optimizations
            num-threads = 4;
            msg-cache-size = "128m";
            rrset-cache-size = "256m";
            cache-min-ttl = 300; # 5 minutes minimum
            cache-max-ttl = 86400; # 24 hours maximum

            # Prefetching for better cache performance
            prefetch = true;
            prefetch-key = true;

            # DNSSEC validation
            auto-trust-anchor-file = "/var/lib/unbound/root.key";
            val-clean-additional = true;
            trust-anchor-signaling = true;

            # Privacy
            hide-identity = true;
            hide-version = true;
            qname-minimisation = true;

            # Performance: SO_REUSEPORT for multi-threaded performance
            so-reuseport = true;

            # Security hardening
            harden-glue = true;
            harden-dnssec-stripped = true;
            harden-below-nxdomain = true;
            harden-referral-path = true;
            harden-algo-downgrade = true;
            use-caps-for-id = true;

            # Access control (localhost + optional LAN)
            access-control = accessControl;

            # Private domains (prevent recursive lookup for local domains)
            private-domain = [ "bigor.lan" ];

            # Logging (minimal for production)
            verbosity = 1;
            log-queries = false;
          };

          # Remote control for stats (optional)
          remote-control = {
            control-enable = true;
            control-interface = "127.0.0.1";
          };
        };
      };

      # Ensure proper permissions for auto-trust-anchor
      systemd.services.unbound = {
        serviceConfig = {
          # Allow unbound to update DNSSEC root trust anchor
          ReadWritePaths = [ "/var/lib/unbound" ];
        };
      };
    }
  );
}
