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
  options.bigor.services.unbound.enable = mkEnableOption "Unbound DNS resolver";

  config = mkIf cfg.enable {
    # Unbound is an internal service (localhost only)
    # No network-topology exposure needed

    services.unbound = {
      enable = true;

      settings = {
        server = {
          # Listen only on localhost (Blocky forwards to it)
          interface = [
            "127.0.0.1"
            "::1"
          ];
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

          # Access control (localhost only)
          access-control = [
            "127.0.0.0/8 allow"
            "::1 allow"
          ];

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
  };
}
