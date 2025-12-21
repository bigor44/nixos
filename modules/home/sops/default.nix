# Module: sops
# Purpose: User-level secret management with age
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.home.sops;
in
{
  options.bigor.home.sops.enable = lib.mkEnableOption "Sops-nix for home-manager";

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
    };
  };
}
