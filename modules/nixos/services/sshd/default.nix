{
  config,
  lib,
  ...
}:
{
  # ============================================================================
  # File: modules/nixos/services/sshd/default.nix
  # Description: OpenSSH Server Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures the SSH daemon for secure remote access with hardening
  #          defaults (no root login, key-based auth only).
  # ============================================================================

  config = lib.mkIf config.bigor.services.ssh.enable {
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
        KbdInteractiveAuthentication = false;
        AllowUsers = [ "bigor" ];
      };
    };
  };
}
