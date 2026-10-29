# Platform: core
# Purpose: Boot, firmware updates, Nix settings, primary user, locale and fonts
{ pkgs, ... }:
{
  # --- Boot Configuration ---
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  # Firmware updates (UEFI, NVMe, peripherals) via LVFS: `fwupdmgr refresh && fwupdmgr update`
  services.fwupd.enable = true;

  # --- Nix Core Configuration ---
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Hardlink duplicates at build time; garbage collection is handled by programs.nh.clean (packages.nix)
      auto-optimise-store = true;
    };
  };

  # --- User ---
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  security.sudo.wheelNeedsPassword = false;

  # --- Localization ---
  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    supportedLocales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  services.xserver.xkb.layout = "fr";

  console = {
    keyMap = "fr";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132b.psf.gz";
  };

  # --- Fonts ---
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      terminus_font
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
        "Noto Color Emoji"
      ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Sans Mono CJK JP"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
