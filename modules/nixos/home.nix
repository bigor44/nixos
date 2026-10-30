# Platform: home
# Purpose: Runs Home Manager as a NixOS module, so user config is activated by each system switch
{
  home-manager = {
    # Reuse the system nixpkgs (and allowUnfree) instead of a separate instance
    useGlobalPkgs = true;
    # Install user packages through users.users.bigor.packages, not ~/.nix-profile
    useUserPackages = true;
    # Rename unmanaged files in the way instead of failing activation
    backupFileExtension = "hm-backup";
    # An old *.hm-backup would otherwise block the next activation
    overwriteBackup = true;
    users.bigor = import ../home;
  };
}
