{
  config,
  lib,
  ...
}:
# Role: Hybrid
# Combines desktop capabilities with remote access (SSH).
# Useful for workstations that are also accessed remotely.
lib.mkIf (config.system.role == "hybrid") {
  desktop.enable = lib.mkDefault true;
  sshd.enable = lib.mkDefault true;
}
