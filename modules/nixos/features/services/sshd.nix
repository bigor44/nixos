# Feature: services-sshd
# Purpose: Hardened OpenSSH server (key-based auth only, no root login)
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.features.services.sshd;
in
{
  options.bigor.features.services.sshd.enable =
    lib.mkEnableOption "OpenSSH daemon with hardened defaults";

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowUsers = [ "bigor" ];
      };
    };
  };
}
