{
  config,
  pkgs,
  ...
}: {
  # ============================================================================
  # System Configuration
  # ============================================================================
  # Defines core system settings:
  # - Bootloader (systemd-boot)
  # - Nix configuration (flakes, binary caches, garbage collection)
  # - Basic networking (hosts, certificates)
  # - Licensing (allowUnfree)
  # ============================================================================
  # ============================================================================
  # Bootloader Configuration
  # ============================================================================
  # We use systemd-boot as it is simple, reliable, and well-integrated with UEFI.
  # ============================================================================
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Keep the boot menu clean
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # ============================================================================
  # Networking
  # ============================================================================
  # Define static hostnames for local machines to ensure reliable resolution
  # without relying on external DNS.
  # ============================================================================
  networking.extraHosts = ''
    ${config.bigor.network.ips.minipc} minipc
    ${config.bigor.network.ips.grospc} grospc
  '';

  # ============================================================================
  # Certificates
  # ============================================================================
  # Trust the internal CA to allow secure communication between local services.
  # ============================================================================
  security.pki.certificateFiles = [../../../certs/minipc-ca.pem];

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
  # ============================================================================
  # Locale & Regional Settings
  # ============================================================================
  # Configures time zone, system language (French default, English supported),
  # and keyboard layout (French).
  # ============================================================================
  time.timeZone = "Europe/Paris";

  # Set system-wide locale to French (France) but keep support for English.
  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    supportedLocales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
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

  # Ensures the correct keymap is available before the graphical environment starts.
  console = {
    keyMap = "fr";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132b.psf.gz";
  };
}
