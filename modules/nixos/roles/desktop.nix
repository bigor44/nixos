{
  config,
  lib,
  ...
}:
lib.mkIf (config.system.role == "desktop") {
  desktop.enable = lib.mkDefault true;
  nfs.client = lib.mkDefault true;
  sshd.enable = lib.mkDefault true;
  monitoring = {
    enable = lib.mkDefault true;
    isServer = lib.mkDefault false;
  };
}
