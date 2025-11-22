{...}: {
  imports = [
    ./sshd.nix
    ./adguard.nix
    ./dashboard.nix
    ./monitoring.nix
    ./cockpit.nix
  ];
}
