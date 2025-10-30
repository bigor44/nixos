{...}: {
  networking.nftables.enable = true;
  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = ["127.0.0.1" "::1"];
    };
    hosts = {
      "192.168.1.1" = ["grospc" "grospc.lan"];
      "192.168.1.10" = ["minipc" "minipc.lan"];
    };
  };
}
