# Platform: home-manager
# Purpose: Home Manager integration for user bigor
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Rename pre-existing files (e.g. zsh's first-run ~/.zshrc) instead of aborting activation
    backupFileExtension = "hm-backup";
    users.bigor = import ../home;
  };
}
