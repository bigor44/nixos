{ ... }:
{
  # Import all core configuration modules.
  # These modules form the base system configuration shared by all hosts.
  imports = [
    ./options.nix
    ./features.nix
    ./system.nix
    ./locale.nix
    ./users.nix
    ./packages.nix
  ];
}
