# Feature: dev-scripts
# Purpose: Development QA scripts for fast quality checks
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.dev.scripts;
in
{
  options.bigor.features.dev.scripts.enable = lib.mkEnableOption "Development QA scripts";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # Script: dns-test
      (pkgs.writeShellApplication {
        name = "dns-test";
        runtimeInputs = with pkgs; [ dnsutils ];
        text = builtins.readFile ../../../../scripts/dns-test.sh;
      })
    ];
  };
}
