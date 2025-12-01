{ ... }:
{
  # Import all core configuration modules.
  # These modules form the base system configuration shared by all hosts.
  imports = [
    ./options.nix # Custom configuration options
    ./system.nix # Bootloader, networking, and Nix settings
    ./locale.nix # Localization and timezone settings
    ./users.nix # User accounts and permissions
    ./packages.nix # Core system packages
  ];
}
