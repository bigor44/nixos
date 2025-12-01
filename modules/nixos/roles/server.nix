{
  config,
  lib,
  ...
}:
# Role: Server
# Activates all infrastructure services and headless operation.
# Includes dashboard, VPN, password manager, and file serving.
lib.mkIf (config.system.role == "server") {
  adblocker.enable = lib.mkDefault true;
  sshd.enable = lib.mkDefault true;
  dashboard.enable = lib.mkDefault true;
  tailscale.enable = lib.mkDefault true;
  vaultwarden.enable = lib.mkDefault true;
  nfs.server = lib.mkDefault true;
  reverse_proxy.enable = lib.mkDefault true;
}
