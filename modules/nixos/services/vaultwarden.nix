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

  # ----------------------------------------------------------------------------
  # Automated Backup Service
  # ----------------------------------------------------------------------------
  # Periodically backs up the SQLite database to an external NFS share.

  # Ensure the backup directory exists with correct permissions.
  systemd = {
    tmpfiles.rules = [
      "d /mnt/storage/backups/vaultwarden 0770 vaultwarden users - -"
    ];

    services.vaultwarden-backup = {
      description = "Backup Vaultwarden SQLite Database";
      serviceConfig = {
        Type = "oneshot";
        # Run as 'vaultwarden' user to access the DB, but with 'users' group
        # to be able to write to the NFS share (owned by bigor/users).
        User = "vaultwarden";
        Group = "users";
      };
      script = ''
        # Configuration
        DATA_DIR="/var/lib/bitwarden_rs"
        LOCAL_BACKUP_DIR="/var/lib/bitwarden_rs/backups"
        EXTERNAL_BACKUP_DIR="/mnt/storage/backups/vaultwarden"
        TIMESTAMP=$(date +%Y%m%d-%H%M)
        BACKUP_FILE="backup-$TIMESTAMP.sqlite3"

        # Ensure directories exist
        mkdir -p $LOCAL_BACKUP_DIR
        mkdir -p $EXTERNAL_BACKUP_DIR

        # 1. Create consistent backup using SQLite API (hot backup)
        ${pkgs.sqlite}/bin/sqlite3 $DATA_DIR/db.sqlite3 ".backup '$LOCAL_BACKUP_DIR/$BACKUP_FILE'"

        # 2. Copy to the external drive (NFS Share) for redundancy
        cp "$LOCAL_BACKUP_DIR/$BACKUP_FILE" "$EXTERNAL_BACKUP_DIR/$BACKUP_FILE"

        # 3. Secure permissions
        # Mode 640: vaultwarden (rw), users (r), others (none).
        chmod 640 "$EXTERNAL_BACKUP_DIR/$BACKUP_FILE"

        # 4. Retention Policy
        # Keep last 14 days on local disk
        find $LOCAL_BACKUP_DIR -name "backup-*.sqlite3" -type f -mtime +14 -delete
        # Keep last 30 days on external storage
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
