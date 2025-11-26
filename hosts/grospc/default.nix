{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "grospc";

  system.role = "desktop";

  powerManagement.cpuFreqGovernor = "performance";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };

  # ============================================================================
  #  BACKUP STRATEGY: PULL FROM SERVER
  # ============================================================================
  # This service copies the Vaultwarden backups from the NFS share (minipc)
  # to the local physical disk (steamlibrary).
  systemd.services.pull-vaultwarden-backups = {
    description = "Sync Vaultwarden backups from minipc to local steamlibrary";
    # Dependency: Only run if the NFS share is actually mounted
    requires = [ "mnt-storage.mount" ];
    after = [ "mnt-storage.mount" ];

    serviceConfig = {
      Type = "oneshot";
      User = "bigor"; # Run as your user (since you own the files now!)
    };

    script = ''
      # Source: NFS Mount (Remote)
      SOURCE="/mnt/storage/backups/vaultwarden"
      # Dest: Local Disk (Safe)
      DEST="/steamlibrary/backups/vaultwarden"

      mkdir -p "$DEST"

      # Rsync ensures we only copy new files
      # -a: Archive mode (preserve timestamps)
      # -v: Verbose
      # --ignore-existing: Don't re-copy files we already have
      ${pkgs.rsync}/bin/rsync -av --ignore-existing "$SOURCE/" "$DEST/"

      # Retention Policy: Keep local desktop copies for 3 months
      find "$DEST" -name "backup-*.sqlite3" -type f -mtime +90 -delete
    '';
  };

  # Run this check every day
  systemd.timers.pull-vaultwarden-backups = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
}
