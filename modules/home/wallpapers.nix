# Module: wallpapers
# Purpose: Synchronize wallpapers from storage to local directory
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.bigor.home.wallpapers;
in
{
  options.bigor.home.wallpapers.enable = mkEnableOption "Wallpaper synchronization";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.rsync ];

    systemd.user.services.sync-wallpapers = {
      Unit = {
        Description = "Sync wallpapers from storage";
        ConditionPathIsMountPoint = "/mnt/storage";
        After = [ "network.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Images/wallpapers";
        # Sync from Storage TO Local.
        ExecStart = "${pkgs.rsync}/bin/rsync -au /mnt/storage/wallpapers/ %h/Images/wallpapers/";
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
