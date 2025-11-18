{lib, ...}: {
  options = {
    role = lib.mkOption {
      type = lib.types.enum ["desktop" "server" "minimal"];
      default = "minimal";
      description = "System role: desktop, server, or minimal";
    };
    adblocker.enable = lib.mkEnableOption "Enable Adguard Home";
  };
}
