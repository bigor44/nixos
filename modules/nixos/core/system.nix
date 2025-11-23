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
    plymouth.enable = true;
  };
  security.pki.certificateFiles = [
    ../../../certs/minipc-ca.pem
  ];

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
    };

    optimise.automatic = true;
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
