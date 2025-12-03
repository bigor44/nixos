{
  config,
  lib,
  ...
}:
lib.mkIf config.glances.enable {
  services.glances = {
    enable = true;
    openFirewall = true; # Automatically opens port 61208
    extraArgs = [
      "--webserver" # Enable Web UI (accessible via browser)
    ];
  };
}
