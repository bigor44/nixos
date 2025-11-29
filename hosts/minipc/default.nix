{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "minipc";

  system.role = "server";

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "amd_pstate=active"
    ];
  };
  powerManagement.cpuFreqGovernor = "schedutil";
  hardware.cpu.amd.updateMicrocode = true;

  systemd.services.network-udp-gro = {
    description = "Enable UDP GRO forwarding for Tailscale";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K ${config.myNetwork.mainInterface} rx-udp-gro-forwarding on rx-gro-list on";
      SuccessExitStatus = "0 1";
    };
  };
}
