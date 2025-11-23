{
  config,
  lib,
  ...
}:
lib.mkIf config.vaultwarden.enable {
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.bigor.lan";
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8222;
      ROCKET_ADDRESS = "127.0.0.1";
    };
  };
}
