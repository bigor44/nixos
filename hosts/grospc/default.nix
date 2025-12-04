{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "grospc";

  # Enable AMD P-State EPP (Replace ACPI CPUFreq)
  # "active" enables the guided mode which allows the governor to work more effectively.
  boot.kernelParams = [ "amd_pstate=active" ];

  system.features = [
    "desktop"
    "nfs-client"
    "sshd"
  ];

  # Performance Tuning
  # Use the 'performance' governor for maximum responsiveness.
  powerManagement.cpuFreqGovernor = "performance";
  # Zen kernel provides better desktop responsiveness and fsync patches.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  myNetwork.mainInterface = "enp14s0";

  # Secondary Storage for Games
  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime" # Reduce write wear
      "nodiratime"
    ];
  };

  # ----------------------------------------------------------------------------
  # Backup Strategy: Pull from Server
  # ----------------------------------------------------------------------------
  # This service pulls Vaultwarden backups from the central server (minipc)
  # to the local desktop storage for redundancy.
  systemd.services.pull-vaultwarden-backups = {
    description = "Sync Vaultwarden backups from minipc to local steamlibrary";
    # Dependency: Ensure NFS share is available before running
    requires = [ "mnt-storage.mount" ];
    after = [ "mnt-storage.mount" ];

    serviceConfig = {
      Type = "oneshot";
      User = "bigor"; # Execute as the user who owns the files
    };

    script = ''
      # Source: NFS Mount (Remote on minipc)
      SOURCE="/mnt/storage/backups/vaultwarden"
      # Destination: Local Disk (Redundant copy)
      DEST="/steamlibrary/backups/vaultwarden"

      mkdir -p "$DEST"

      # Rsync synchronization:
      # -a: Archive mode (preserve attributes)
      # -v: Verbose
      # --ignore-existing: Only copy new backups to avoid re-transferring
      ${pkgs.rsync}/bin/rsync -av --ignore-existing "$SOURCE/" "$DEST/"

      # Retention Policy:
      # Keep local copies for 90 days to balance storage usage vs safety.
      find "$DEST" -name "backup-*.sqlite3" -type f -mtime +90 -delete
    '';
  };

  # Schedule the backup pull daily.
  systemd.timers.pull-vaultwarden-backups = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true; # Run immediately if missed while off
      RandomizedDelaySec = "10m"; # Avoid thundering herd (though unlikely here)
    };
  };
}
