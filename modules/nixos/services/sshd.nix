{
  config,
  lib,
  ...
}:
lib.mkIf config.sshd.enable {
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # Security Hardening
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
