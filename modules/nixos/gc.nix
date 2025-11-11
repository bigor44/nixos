/*
  Title: Nix Garbage Collector Configuration
  Description: Configures automatic Nix garbage collection to free up disk space.
*/
{
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 8d";
    persistent = true;
  };
  boot.loader.systemd-boot.configurationLimit = 10;
}
