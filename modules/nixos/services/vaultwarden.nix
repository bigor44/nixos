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

  # Ensure the backup directory exists with correct permissions before the service runs
  systemd = {
    tmpfiles.rules = [
      "d /mnt/storage/backups/vaultwarden 0770 vaultwarden users - -"
    ];

    services.vaultwarden-backup = {
      description = "Backup Vaultwarden SQLite Database";
      serviceConfig = {
        Type = "oneshot";
        # Run as the service user, not root
        User = "vaultwarden";
        # Run as 'users' group so 'bigor' (GID 100) can read the files via NFS
        Group = "users";
      };
      script = ''
        # Paths
        DATA_DIR="/var/lib/bitwarden_rs"
        # Note: The service creates this, vaultwarden user has access
        LOCAL_BACKUP_DIR="/var/lib/bitwarden_rs/backups" 
        EXTERNAL_BACKUP_DIR="/mnt/storage/backups/vaultwarden"

        mkdir -p $LOCAL_BACKUP_DIR
        # External dir is handled by tmpfiles, but mkdir -p is safe to keep
        mkdir -p $EXTERNAL_BACKUP_DIR 

        TIMESTAMP=$(date +%Y%m%d-%H%M)
        BACKUP_FILE="backup-$TIMESTAMP.sqlite3"

        # 1. Create consistent backup using SQLite API
        ${pkgs.sqlite}/bin/sqlite3 $DATA_DIR/db.sqlite3 ".backup '$LOCAL_BACKUP_DIR/$BACKUP_FILE'"

        # 2. Copy to the separate drive
        cp "$LOCAL_BACKUP_DIR/$BACKUP_FILE" "$EXTERNAL_BACKUP_DIR/$BACKUP_FILE"

        # 3. Secure permissions
        # We don't need chown anymore because we are running as vaultwarden:users
        # Mode 640 ensures vaultwarden (rw), users group (r), others (none)
        chmod 640 "$EXTERNAL_BACKUP_DIR/$BACKUP_FILE"

        # 4. Retention Policy: Keep last 30 days on storage, 14 days locally
        find $LOCAL_BACKUP_DIR -name "backup-*.sqlite3" -type f -mtime +14 -delete
        find $EXTERNAL_BACKUP_DIR -name "backup-*.sqlite3" -type f -mtime +30 -delete
      '';
    };

    timers.vaultwarden-backup = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
