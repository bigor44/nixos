{ ... }:
{
  imports = [
    ./sshd.nix
    ./adguard.nix
    ./dashboard.nix
    ./monitoring.nix
    ./monitoring-alerts.nix
    ./nfs.nix
    ./caddy.nix
    ./tailscale.nix
    ./vaultwarden.nix
  ];
}
