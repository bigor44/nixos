# Entry point for NixOS custom modules.
# This module aggregates all core configurations, roles, desktop environments,
# and system services into a single importable unit.
{ ... }:
{
  imports = [
    ./core
    ./desktop
    ./services
  ];
}
