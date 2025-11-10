{ config, pkgs, lib, desktop, ... }:

with lib;

let
  cfg = desktop;
in
{
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
