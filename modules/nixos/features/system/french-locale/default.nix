# ============================================================================
# File: modules/nixos/features/system/french-locale/default.nix
# Description: Configures French locale, time zone, and keyboard layout.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{ pkgs, ... }:
{
  # ============================================================================
  # Locale & Regional Settings
  # ============================================================================
  # Configures time zone, system language (French default, English supported),
  # and keyboard layout (French).
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
