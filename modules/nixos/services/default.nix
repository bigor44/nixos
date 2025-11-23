{...}: {
  imports = [
    ./sshd.nix
    ./adguard.nix
    ./dashboard.nix
    ./monitoring.nix
    ./nfs.nix
    ./caddy.nix
  ];
}
