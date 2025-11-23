{pkgs, ...}: {
  # Fuseau horaire
  time.timeZone = "Europe/Paris";

  # Langue et formatage
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

  # Clavier X11 (Graphique)
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Clavier & Police Console (TTY)
  console = {
    keyMap = "fr";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132b.psf.gz";
  };
}
