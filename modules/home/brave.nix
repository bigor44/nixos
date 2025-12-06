{
  lib,
  osConfig,
  pkgs,
  ...
}:
lib.mkIf osConfig.roles.desktop {
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--password-store=basic"
      "--ozone-platform=wayland"
    ];
  };
}
