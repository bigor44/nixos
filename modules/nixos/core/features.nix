{ config, lib, ... }:
let
  cfg = config.system.features;
in
{
  config = lib.mkMerge [
    # --- Feature: Server ---
    (lib.mkIf cfg.server {
      adblocker.enable = lib.mkDefault true;
      dashboard.enable = lib.mkDefault true;
      tailscale.enable = lib.mkDefault true;
      vaultwarden.enable = lib.mkDefault true;
      nfs.server = lib.mkDefault true;
      reverse_proxy.enable = lib.mkDefault true;
      glances.enable = lib.mkDefault true;
    })
  ];
}
