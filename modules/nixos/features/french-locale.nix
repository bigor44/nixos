# Feature: french-locale
# Purpose: French locale, timezone, and keyboard layout (Paris)
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.features.french-locale;
in
{
  options.bigor.features.french-locale = {
    enable = mkEnableOption "French locale, timezone, and keyboard layout";
  };

  config = mkIf cfg.enable {
    time.timeZone = "Europe/Paris";

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

    console = {
      keyMap = "fr";
      font = "${pkgs.terminus_font}/share/consolefonts/ter-132b.psf.gz";
    };
  };
}
