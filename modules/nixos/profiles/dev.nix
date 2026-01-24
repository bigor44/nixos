# Profile: dev
# Purpose: Development tools
{ lib, config, ... }:
let
  enabled = builtins.elem "dev" config.bigor.profiles;
in
{
  config = lib.mkIf enabled {
    bigor.features.dev = {
      tools.enable = true;
      scripts.enable = true;
      nixvim.enable = true;
    };
  };
}
