{ config
, lib
, ...
}:
lib.mkIf config.roles.homelab_master {
  services.glances = {
    enable = true;
    openFirewall = false;
  };
}
