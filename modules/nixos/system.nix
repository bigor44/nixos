{
  pkgs,
  lib,
  ...
}: {
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
      "splash"
    ];
  };

  # Nix configuration enhancements
  nix = {
    settings = {
      auto-optimise-store = true;
      # Enable flakes and new commands
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Parallel builds
      max-jobs = lib.mkDefault 8;
      # Substitute from cache
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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8d";
      persistent = true;
    };
  };

  # Locale configuration (existing is good)
  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  console = {
    keyMap = "fr";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132b.psf.gz";
  };
}
