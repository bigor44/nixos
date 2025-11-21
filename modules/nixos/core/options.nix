{lib, ...}: {
  options = {
    desktop.enable = lib.mkEnableOption "Enable Cosmic Desktop";
    sshd.enable = lib.mkEnableOption "Enable SSH Server";
    dashboard.enable = lib.mkEnableOption "Enable Homepage Dashboard";
  };
}
