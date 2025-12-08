# Service Aggregation Module
# ------------------------------------------------------------------------------
# Imports all optional system services. These are typically enabled via
# the flags defined in `modules/nixos/core/options.nix`.
# ------------------------------------------------------------------------------
{...}: {
  imports = [
    ./sshd.nix
    ./adguard.nix
    ./dashboard.nix
    ./nfs.nix
    ./caddy.nix
    ./tailscale.nix
    ./glances.nix
    ./prometheus.nix
    ./grafana.nix
    ./alert-manager.nix
  ];
}
