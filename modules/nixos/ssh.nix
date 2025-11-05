/*
Title: SSH Server Configuration
Description: Configures the OpenSSH server with secure settings.
*/
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
