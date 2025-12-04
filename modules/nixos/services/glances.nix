{
  config,
  lib,
  ...
}:
lib.mkIf config.glances.enable {
  services.glances = {
    enable = true;
    openFirewall = false;
  };
}
