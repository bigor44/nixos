{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.vaultwarden.enable {
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.bigor.lan";
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8222;
      ROCKET_ADDRESS = "127.0.0.1";
    };
  };
  systemd.services.vaultwarden-backup = {
    description = "Backup Vaultwarden SQLite Database";
    serviceConfig = {
      Type = "oneshot";
      User = "vaultwarden";
      Group = "vaultwarden";
    };
    script = ''
      BACKUP_DIR="/var/lib/bitwarden_rs/backups"
      DATA_DIR="/var/lib/bitwarden_rs"

      mkdir -p $BACKUP_DIR

      # Backup via SQLite pour assurer l'intégrité même si le service tourne
      ${pkgs.sqlite}/bin/sqlite3 $DATA_DIR/db.sqlite3 ".backup '$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M).sqlite3'"

      # Garder seulement les 14 derniers backups
      find $BACKUP_DIR -name "backup-*.sqlite3" -type f -mtime +14 -delete
    '';
  };

  systemd.timers.vaultwarden-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
