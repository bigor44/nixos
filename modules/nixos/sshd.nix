{
  config,
  lib,
  ...
}:
lib.mkIf (config.role == "server") {
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
