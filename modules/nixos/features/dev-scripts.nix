# Feature: dev-scripts
# Purpose: Development QA scripts for fast quality checks
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.features.dev-scripts;

  # Helper to create scripts from external files
  mkScript =
    name: src: inputs:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = inputs;
      text = builtins.readFile src;
    };

  # Script: check-quick
  check-quick = mkScript "check-quick" ../../../scripts/check-quick.sh (
    with pkgs;
    [
      git
      treefmt
      statix
      deadnix
      shellcheck
    ]
  );

  # Script: check-full
  check-full = mkScript "check-full" ../../../scripts/check-full.sh (
    with pkgs;
    [
      git
      treefmt
      statix
      deadnix
      nix
      shellcheck
    ]
  );

  # Script: check-mega
  check-mega = mkScript "check-mega" ../../../scripts/check-mega.sh (
    with pkgs;
    [
      git
      check-quick
      check-full
    ]
  );

  # Script: dns-test
  dns-test = mkScript "dns-test" ../../../scripts/dns-test.sh (
    with pkgs;
    [
      dnsutils
    ]
  );

  # Script: install-git-hooks
  install-git-hooks = mkScript "install-git-hooks" ../../../scripts/install-git-hooks.sh (
    with pkgs;
    [
      git
      sops
      check-quick
    ]
  );
in
{
  options.bigor.features.dev-scripts.enable = lib.mkEnableOption "Development QA scripts";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      check-quick
      check-full
      check-mega
      dns-test
      install-git-hooks
    ];
  };
}
