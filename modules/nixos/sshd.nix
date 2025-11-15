{
  config,
  lib,
  ...
}:
lib.mkIf config.server.enable {
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
