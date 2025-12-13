{
  config,
  lib,
  pkgs,
  ...
}:
# ============================================================================
# Desktop Applications (GUI)
# ============================================================================
# Installs graphical applications and manages dotfiles for desktop components.
# ============================================================================
with lib; let
  cfg = config.bigor.home.gui-packages;
in {
  options.bigor.home.gui-packages = {
    enable = mkEnableOption "Enable user desktop apps";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      onedrive
      youtube-music
      whatsapp-electron
      antigravity-fhs
      brave
      pkgs.bigor.turtle-wow
    ];
    xdg.configFile = {
      # Symlink mutable configuration files from the local repository.
      # mkOutOfStoreSymlink allows editing files in ~/nixos/dotfiles/ and
      # seeing changes immediately without rebuilding.
      cosmic.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/cosmic";
      autostart.source = ../../../dotfiles/autostart;
    };
  };
}
