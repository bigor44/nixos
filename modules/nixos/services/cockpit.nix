{
  config,
  lib,
  ...
}:
lib.mkIf config.cockpit.enable {
  services.cockpit = {
    enable = true;
    openFirewall = true;
  };
}
