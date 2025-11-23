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
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
