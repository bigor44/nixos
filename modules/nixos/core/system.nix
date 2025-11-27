_: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  #Networking
  networking = {
    extraHosts = ''
      192.168.1.10 minipc
      192.168.1.11 grospc
    '';
    usePredictableInterfaceNames = false;
  };

  # Certificat de Caddy
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
      max-jobs = "auto";
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
