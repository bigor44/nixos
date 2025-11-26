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
      # Run as root to ensure write access to /mnt/storage
      User = "root";
      Group = "root";
    };
    script = ''
      # Paths
      DATA_DIR="/var/lib/bitwarden_rs"
      LOCAL_BACKUP_DIR="/var/lib/bitwarden_rs/backups"
      # Backup to the separate drive (minipc storage)
      EXTERNAL_BACKUP_DIR="/mnt/storage/backups/vaultwarden"

      mkdir -p $LOCAL_BACKUP_DIR
      mkdir -p $EXTERNAL_BACKUP_DIR

      TIMESTAMP=$(date +%Y%m%d-%H%M)
      BACKUP_FILE="backup-$TIMESTAMP.sqlite3"

      # 1. Create consistent backup using SQLite API
      ${pkgs.sqlite}/bin/sqlite3 $DATA_DIR/db.sqlite3 ".backup '$LOCAL_DIR/$BACKUP_FILE'"

      # 2. Copy to the separate drive
      cp "$LOCAL_DIR/$BACKUP_FILE" "$EXTERNAL_BACKUP_DIR/$BACKUP_FILE"

      # 3. Fix permissions so 'bigor' (1000) can manage them via NFS/SSH
      chown 1000:100 "$EXTERNAL_BACKUP_DIR/$BACKUP_FILE"
      chmod 640 "$EXTERNAL_BACKUP_DIR/$BACKUP_FILE"

      # 4. Retention Policy: Keep last 30 days on storage, 14 days locally
      find $LOCAL_BACKUP_DIR -name "backup-*.sqlite3" -type f -mtime +14 -delete
      find $EXTERNAL_BACKUP_DIR -name "backup-*.sqlite3" -type f -mtime +30 -delete
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
