{
  lib,
  config,
  ...
}:
lib.mkIf config.podman.enable {
  networking.firewall.allowedTCPPorts = [8123];
  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = ["home-assistant:/config"];
      environment.TZ = "Europe/Paris";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      extraOptions = [
        "--network=host"
      ];
    };
  };
}
