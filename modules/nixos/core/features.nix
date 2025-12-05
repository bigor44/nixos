{ config, lib, ... }:
let
  cfg = config.system.features;
  hasFeature = f: lib.elem f cfg;
in
{
  config = lib.mkMerge [
    # --- Feature: Desktop ---
    (lib.mkIf (hasFeature "desktop") {
      desktop.enable = true;
    })

    # --- Feature: Server ---
    (lib.mkIf (hasFeature "server") {
      adblocker.enable = lib.mkDefault true;
      dashboard.enable = lib.mkDefault true;
      tailscale.enable = lib.mkDefault true;
      vaultwarden.enable = lib.mkDefault true;
      nfs.server = lib.mkDefault true;
      reverse_proxy.enable = lib.mkDefault true;
      glances.enable = lib.mkDefault true;
    })

    # --- Feature: Binary Cache ---
    (lib.mkIf (hasFeature "binary-cache") {
      binary_cache.enable = true;
    })

    # --- Feature: SSHD ---
    # Replaces the old "hybrid" role which was just desktop + sshd
    (lib.mkIf (hasFeature "sshd") {
      sshd.enable = true;
    })

    # --- Feature: NFS Client ---
    (lib.mkIf (hasFeature "nfs-client") {
      nfs.client = true;
    })
  ];
}
