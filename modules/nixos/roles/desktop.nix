{
  config,
  lib,
  ...
}:
lib.mkIf (config.system.role == "desktop") {
  desktop.enable = lib.mkDefault true;
  sshd.enable = lib.mkDefault false;
  monitoring = {
    enable = lib.mkDefault true;
    isServer = lib.mkDefault false;
  };
}
