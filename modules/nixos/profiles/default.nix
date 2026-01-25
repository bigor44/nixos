# Platform: profiles
# Purpose: Aggregator for all profiles
{
  imports = [
    ./manager.nix
    ./desktop.nix
    ./dev.nix
    ./server.nix
    ./homelab-master.nix
  ];
}
