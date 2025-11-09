/*
  Title: Network Configuration
  Description: Configures networking, including NetworkManager, nftables, and host file entries.
*/
{
  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [
        "127.0.0.1"
        "::1"
      ];
    };
    hosts = {
      "192.168.1.1" = [
        "grospc"
        "grospc.bigor.lan"
      ];
      "192.168.1.10" = [
        "minipc"
        "minipc.bigor.lan"
      ];
    };
  };
}
