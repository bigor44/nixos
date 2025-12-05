{
  config,
  lib,
  ...
}:
let
  cfg = config.binary_cache;
in
{
  config = lib.mkIf cfg.enable {
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/var/lib/nix-serve/cache-priv-key.pem";
    };

    networking.firewall.allowedTCPPorts = [ config.services.nix-serve.port ];
  };
}
