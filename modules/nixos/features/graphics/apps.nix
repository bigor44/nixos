# Feature: graphics-apps
# Purpose: User-level desktop applications and dotfiles (migrated from HM)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.graphics.apps;
  user = "bigor";
  homeDir = "/home/${user}";
  dotfilesPath = "${homeDir}/nixos/dotfiles";
in
{
  options.bigor.features.graphics.apps.enable = lib.mkEnableOption "User-level desktop applications";

  config = lib.mkIf cfg.enable {
    users.users.${user}.packages = with pkgs; [
      prismlauncher
      discord
      whatsapp-electron
      brave
      rsync # For wallpaper sync
    ];

    systemd = {
      # Replicate HM's mkOutOfStoreSymlink using systemd.tmpfiles.rules
      tmpfiles.rules = [
        "L+ ${homeDir}/.config/cosmic - ${user} users - ${dotfilesPath}/cosmic"
        "L+ ${homeDir}/.config/autostart - ${user} users - ${dotfilesPath}/autostart"
      ];

      # Wallpaper synchronization service
      user.services.sync-wallpapers = {
        description = "Sync wallpapers from storage";
        unitConfig = {
          ConditionPathIsMountPoint = "/mnt/storage";
          After = [ "network.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${homeDir}/Images/wallpapers";
          ExecStart = "${pkgs.rsync}/bin/rsync -au /mnt/storage/wallpapers/ ${homeDir}/Images/wallpapers/";
        };
        wantedBy = [ "default.target" ];
      };

      user.timers.sync-wallpapers = {
        description = "Sync wallpapers periodically";
        timerConfig = {
          OnBootSec = "5m";
          OnUnitActiveSec = "1h";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
