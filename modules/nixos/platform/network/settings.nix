# Platform: system.network
# Purpose: Network configuration constants (subnet, domain)
{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    optional
    mkIf
    concatStringsSep
    mapAttrsToList
    ;
  cfg = config.bigor.network;
in
{
  options.bigor.network = {
    subnet = mkOption {
      type = types.strMatching "^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$";
      default = "192.168.1.0/24";
      description = "Network subnet in CIDR notation (e.g., 192.168.1.0/24)";
    };

    domain = mkOption {
      type = types.str;
      default = "bigor.lan";
      description = "Local domain name for all hosts (e.g., bigor.lan)";
      readOnly = true;
    };

    hosts = mkOption {
      type = types.attrsOf types.str;
      default = {
        "minipc" = "192.168.1.10";
        "grospc" = "192.168.1.11";
      };
      description = "Static IP mappings for known hosts";
    };
    serviceRecords = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Service DNS records (service → IP)";
    };
  };

  config = {
    warnings = optional (cfg.domain == "") "bigor.network.domain is not set";

    # Enable nftables (modern firewall backend)
    networking.nftables.enable = true;
    networking.extraHosts = mkIf (cfg.hosts != { }) (
      concatStringsSep "\n" (mapAttrsToList (name: ip: "${ip} ${name}") cfg.hosts)
    );
  };
}
