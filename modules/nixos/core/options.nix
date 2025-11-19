{lib, ...}: {
  options = {
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
    desktop.enable = lib.mkEnableOption "Enable Cosmic Desktop";
    sshd.enable = lib.mkEnableOption "Enable SSH Server";
    dashboard.enable = lib.mkEnableOption "Enable Homepage Dashboard";
  };
}
