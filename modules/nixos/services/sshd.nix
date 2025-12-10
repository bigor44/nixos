{
  config,
  lib,
  ...
}: {
  # ============================================================================
  # OpenSSH Server
  # ============================================================================
  # Configures the SSH daemon for secure remote access.
  # Enforces hardening best practices:
  # - No root login
  # - Key-based authentication only (no passwords)
  # ============================================================================
  config = lib.mkIf config.bigor.sshd.enable {
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
  };
}
