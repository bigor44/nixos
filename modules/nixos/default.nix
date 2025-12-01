# Entry point for NixOS custom modules.
# This module aggregates all core configurations, roles, desktop environments,
# and system services into a single importable unit.
{ ... }:
{
  imports = [
    ./core
    ./roles
    ./desktop
    ./services
  ];

  # The release version of the first install of this system.
  # This dictates the default settings for stateful data (e.g., PostgreSQL).
  # Do not change this unless you know what you are doing.
  system.stateVersion = "25.05";
}
