# Host: minidesk
# Purpose: Portable workstation (can use local storage when available)
{ ... }:
{
  # Reuse minipc hardware config (same hardware base)
  imports = [ ../minipc/hardware-configuration.nix ];

  networking.hostName = "minidesk";
  system.stateVersion = "25.11";

  bigor = {
    # Policies: strategic decisions
    policies = {
      kernel = "desktop";
      power = "amd-pstate";
      dns.mode = "portable";
      storage = {
        mode = "local";
        device = "/dev/disk/by-uuid/a1ee534d-78d8-42df-be26-9cadae8197cf";
      };
    };

    # Profile and overrides
    profiles.workstation.enable = true;
    services.ssh.enable = true;
  };
}
