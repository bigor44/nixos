{
  lib,
  config,
  ...
}:
lib.mkIf config.desktop.enable {
  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [
        "127.0.0.1"
        "::1"
      ];
    };
  };
}
