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
      # Disable root login to prevent direct administrative access via SSH.
      PermitRootLogin = "no";
      # Disable password authentication to enforce the use of SSH keys,
      # which protects against brute-force password attacks.
      PasswordAuthentication = false;
    };
  };
}
