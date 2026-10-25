# Platform: desktop
# Purpose: COSMIC desktop, NetworkManager, Firefox, Flatpak, PipeWire, Bluetooth and gaming (Steam, GameMode)
{ config, ... }:
{
  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    flatpak.enable = true;

  };

  networking.networkmanager = {
    enable = true;
    # Local DNS server, placed ahead of the DHCP-provided ones in resolv.conf
    insertNameservers = [ "192.168.1.10" ];
  };
  programs = {
    firefox.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # NixOS has no declarative Flatpak remotes; add Flathub once the network is up
  systemd.services.flatpak-add-flathub = {
    description = "Add Flathub repository to Flatpak";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.services.flatpak.package}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
  };
}
