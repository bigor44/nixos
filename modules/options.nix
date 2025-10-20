{ lib, ... }:

{
  options = {
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    desktop.enable = lib.mkEnableOption "Enable desktop environment";
    sshserver.enable = lib.mkEnableOption "Enable SSH Server";
  };
}
