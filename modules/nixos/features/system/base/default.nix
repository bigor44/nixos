{ inputs, ... }:
{
  # ============================================================================
  # File: modules/nixos/features/system/base/default.nix
  # Description: Base system configuration for all NixOS hosts.
  # Author: Bigor
  # Date: 2025-12-18
  # ============================================================================

  # ============================================================================
  # Certificates
  # ============================================================================
  # Trust the internal CA to allow secure communication between local services.
  security.pki.certificateFiles = [ "${inputs.self}/certs/minipc-ca.pem" ];

  # Allow proprietary software (drivers, codecs, etc.)
  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # Nix Configuration
  # ============================================================================
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";

      # Binary Caches
      # Use upstream caches and the Cosmic cache to speed up builds
      # by downloading pre-built binaries.
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org"
      ];
      # Trusted Public Keys
      # These keys authorize the substituters listed above.
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
    };
    # Deduplicate files in the Nix store to save space.
    # Note: This runs on every build, which can slightly slow down builds
    # but saves significant disk space.
    optimise.automatic = true;
  };
}
