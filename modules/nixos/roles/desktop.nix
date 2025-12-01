{
  config,
  lib,
  ...
}:
# Role: Desktop
# Activates the full graphical environment and client-side file sharing.
lib.mkIf (config.system.role == "desktop") {
  desktop.enable = lib.mkDefault true;
  nfs.client = lib.mkDefault true;
}
