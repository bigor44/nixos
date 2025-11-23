{ config
, lib
, ...
}:
lib.mkIf (config.system.role == "hybrid") {
  desktop.enable = lib.mkDefault true;
  sshd.enable = lib.mkDefault true;
}
