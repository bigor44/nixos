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

  # Helper to create scripts from external files
  mkScript =
    name: src: inputs:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = inputs;
      text = builtins.readFile src;
    };

  # Script: dns-test
  dns-test = mkScript "dns-test" ../../../../scripts/dns-test.sh (
    with pkgs;
    [
      dnsutils
    ]
  );
in
{
  options.bigor.features.dev.scripts.enable = lib.mkEnableOption "Development QA scripts";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      dns-test
    ];
  };
}
