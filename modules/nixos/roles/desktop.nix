{
  config,
  lib,
  ...
}:
lib.mkIf (config.system.role == "desktop") {
  desktop.enable = lib.mkDefault true;
  nfs.client = lib.mkDefault true;
}
