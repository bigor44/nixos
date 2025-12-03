{
  config,
  lib,
  ...
}:
lib.mkIf config.glances.enable {
  services.glances = {
    enable = true;
    openFirewall = false; # Opens port 61208 only to localhost
  };
}
