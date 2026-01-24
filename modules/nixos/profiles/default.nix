# Platform: profiles
# Purpose: High-level host profiles enabling groups of features
{ lib, config, ... }:
let
  inherit (lib) mkOption types;

  allowedProfiles = [
    "desktop"
    "dev"
    "server"
    "homelab-master"
  ];

  unknownProfiles = builtins.filter (p: !builtins.elem p allowedProfiles) config.bigor.profiles;
in
{
  options.bigor.profiles = mkOption {
    type = types.listOf types.str;
    default = [ ];
    description = "High-level host profiles";
  };

  imports = [
    ./desktop.nix
    ./dev.nix
    ./server.nix
    ./homelab-master.nix
  ];

  config.assertions = [
    {
      assertion = unknownProfiles == [ ];
      message = ''
        Unknown profile(s) in bigor.profiles:
          ${builtins.concatStringsSep ", " unknownProfiles}

        Allowed profiles are:
          ${builtins.concatStringsSep ", " allowedProfiles}
      '';
    }
  ];
}
