# Platform: firewall
# Purpose: Basic firewall configuration
{
  config = {
    networking.firewall = {
      enable = true;
      # Allow ping from LAN
      allowPing = true;
      # Log refused connections for debugging
      logRefusedConnections = false;
    };
  };
}
