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
      "--ozone-platform-hint=auto"
      "--enable-features=WaylandWindowDecorations"
    ];
  };
}
