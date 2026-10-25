# Flake: home-manager
# Purpose: Home Manager integration bridge
{ inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Rename pre-existing files (e.g. zsh's first-run ~/.zshrc) instead of aborting activation
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };
    users.bigor = import ../modules/home;
  };
}
