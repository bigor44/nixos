# ============================================================================
# File: modules/nixos/sops-nix/default.nix
# Description: Configures sops-nix for secret management.
# Author: Bigor
# Date: 2025-12-16
# ============================================================================
{
  # Sops-nix configuration
  sops = {
    # Default location for the encrypted secrets file.
    defaultSopsFile = ../../../secrets/secrets.yaml;
    # Default format for the secrets file.
    defaultSopsFormat = "yaml";
    # Location of the age key file for decryption.
    # This key is managed by the system and should be protected.
    age.keyFile = "/var/lib/sops-nix/key.txt";
  };
}
