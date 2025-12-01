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
      PermitRootLogin = "no"; # Disable root login
      PasswordAuthentication = false; # Require SSH keys
    };
  };
}
