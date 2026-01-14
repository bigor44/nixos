# Module: sshd
# Purpose: Hardened OpenSSH server (key-based auth only, no root login)
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.capabilities.sshd;
in
{
  options.bigor.capabilities.sshd.enable = mkEnableOption "OpenSSH daemon with hardened defaults";

  config = mkIf cfg.enable {
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
