{lib, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # Silent boot (optional)
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
    ];
  };
  security.pki.certificateFiles = [
    ../../../certs/minipc-ca.pem
  ];
  nixpkgs.config.allowUnfree = true;

  # Nix configuration enhancements
  nix = {
    settings = {
      auto-optimise-store = true;
      # Enable flakes and new commands
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = lib.mkDefault 8;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    optimise.automatic = true;
  };
}
