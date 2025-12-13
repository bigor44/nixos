{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.bigor.home.git;
in {
  # 1. Définition de l'option (Feature Flag)
  options.bigor.home.git = {
    enable = mkEnableOption "Enable user git configuration";
  };

  # 2. Configuration conditionnelle
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Yoann Bigor";
        email = "bigor44@gmail.com";
      };
    };
  };
}
