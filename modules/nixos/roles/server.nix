{
  config,
  lib,
  ...
}:
lib.mkIf (config.system.role == "server") {
  desktop.enable = lib.mkDefault false;
  sshd.enable = lib.mkDefault true;
  dashboard.enable = lib.mkDefault true;
  nfs.server = lib.mkDefault true;
  monitoring = {
    enable = lib.mkDefault true;
    isServer = lib.mkDefault true;
  };
}
