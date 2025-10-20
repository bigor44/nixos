{ lib, ... }:

{
  options = {
    audio.enable = lib.mkEnableOption "Enable Audio";
    bluetooth.enable = lib.mkEnableOption "Enable bluetooth";
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    podman.enable = lib.mkEnableOption "Enable Podman";
    desktop.enable = lib.mkEnableOption "Enable desktop environment";
    sshserver.enable = lib.mkEnableOption "Enable SSH Server";
  };
}
