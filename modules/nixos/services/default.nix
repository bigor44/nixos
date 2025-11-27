{...}: {
  imports = [
    ./sshd.nix
    ./adguard.nix
    ./dashboard.nix
    ./nfs.nix
    ./caddy.nix
    ./tailscale.nix
    ./vaultwarden.nix
    ./netdata.nix
  ];
}
