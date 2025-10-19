{ lib, ... }:

{
  options = {
    desktop.enable = lib.mkEnableOption "Enable desktop environment";
    sshserver.enable = lib.mkEnableOption "Enable SSH Server";
  };
}
