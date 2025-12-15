{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.services.ssh;
in
{
  # ============================================================================
  # File: modules/nixos/services/sshd/default.nix
  # Description: OpenSSH Server Configuration
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Configures the SSH daemon for secure remote access with hardening
  #          defaults (no root login, key-based auth only).
  # ============================================================================

  options.bigor.services.ssh = {
    enable = mkEnableOption "Enables the OpenSSH daemon with hardened security defaults (no root login, key-based auth only)";
  };

  config = mkIf cfg.enable {
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
