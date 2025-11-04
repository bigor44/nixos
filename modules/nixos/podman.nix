/*
  Title: Podman Configuration
  Description: Enables and configures Podman for container management.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.podman.enable {
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
  ];
}
