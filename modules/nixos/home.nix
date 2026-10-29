# Platform: NixOS
# Purpose: Home Manager as a NixOS module; user config is applied with each system switch
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Pre-existing unmanaged files are renamed instead of failing home-manager-bigor.service
    backupFileExtension = "hm-backup";
    # A leftover backup from an earlier conflict would otherwise block activation again
    overwriteBackup = true;
    users.bigor = import ../home;
  };
}
