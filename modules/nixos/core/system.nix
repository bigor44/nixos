{ config, ... }:
{
  # Bootloader Configuration
  # We use sstemd-boot as it is simple, reliable, and well-integrated with UEFI.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Keep the boot menu clean
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Networking
  # Define static hostnames for local machines to ensure reliable resolution
  # without relying on external DNS.
  networking.extraHosts = ''
    ${config.myNetwork.ips.minipc} minipc
    ${config.myNetwork.ips.grospc} grospc
  '';

  # Certificates
  # Trust the internal CA to allow secure communication between local services.
  security.pki.certificateFiles = [
    ../../../certs/minipc-ca.pem
  ];

  # Allow proprietary software (drivers, codecs, etc.)
  nixpkgs.config.allowUnfree = true;

  # Nix Configuration
  nix = {
    settings = {
      auto-optimise-store = true; # Deduplicate identical files in the store
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto"; # Utilize all available CPU cores for building

      # Binary Caches
      # Use upstream caches and the Cosmic cache to speed up builds
      # by downloading pre-built binaries.
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
    };
    # Periodic garbage collection is handled by 'nh'
    optimise.automatic = true;
  };
}
