{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.bigor.policies.kernel;
in
{
  options.bigor.policies.kernel = mkOption {
    type = types.enum [
      "server"
      "desktop"
      "hardened"
      "latest"
    ];
    default = "server";
    description = ''
      Kernel selection policy:
      - "server": LTS kernel for stability (linuxPackages)
      - "desktop": Zen kernel for performance (linuxPackages_zen)
      - "hardened": Security-focused kernel (linuxPackages_hardened)
      - "latest": Latest mainline kernel (linuxPackages_latest)
    '';
  };

  config.boot.kernelPackages =
    {
      server = pkgs.linuxPackages;
      desktop = pkgs.linuxPackages_zen;
      hardened = pkgs.linuxPackages_hardened;
      latest = pkgs.linuxPackages_latest;
    }
    .${cfg};
}
