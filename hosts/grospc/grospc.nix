{
  imports = [
    ../../modules/nixos/nfs-client.nix
  ];
  networking.hostName = "grospc";
  desktop.enable = true;
  server.enable = false;
  adblocker.enable = true;
}
