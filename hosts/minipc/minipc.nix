{
  imports = [
    ../../modules/nixos/nfs-server.nix
  ];
  networking.hostName = "minipc";
  desktop.enable = false;
  server.enable = true;
  adblocker.enable = true;
}
