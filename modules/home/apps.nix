# Home: apps
# Purpose: User-level desktop applications and wallpaper sync
{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf (osConfig.bigor.features.graphics.desktop.enable or false) {
    home.packages = with pkgs; [
      prismlauncher
      discord
      whatsapp-electron
      brave
      rsync
    ];

    systemd.user.services.sync-wallpapers = {
      Unit = {
        Description = "Sync wallpapers from storage";
        ConditionPathIsMountPoint = "/mnt/storage";
        After = [ "network.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${config.home.homeDirectory}/Images/wallpapers";
        ExecStart = "${pkgs.rsync}/bin/rsync -au /mnt/storage/wallpapers/ ${config.home.homeDirectory}/Images/wallpapers/";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    systemd.user.timers.sync-wallpapers = {
      Unit = {
        Description = "Sync wallpapers periodically";
      };
      Timer = {
        OnBootSec = "5m";
        OnUnitActiveSec = "1h";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
