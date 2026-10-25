# Platform: firewall
# Purpose: Basic firewall configuration (nftables backend)
{
  config = {
    networking.nftables.enable = true;

    networking.firewall = {
      enable = true;
      # Allow ping from LAN
      allowPing = true;
      # Log refused connections for debugging
      logRefusedConnections = false;
    };
  };
}
