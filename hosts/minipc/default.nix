{
  config,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "minipc";

  system.features = [
    "server"
    "sshd"
  ];

  # Kernel & Power Management
  # Use the standard kernel for stability.
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "amd_pstate=active" # Enable AMD P-State driver for better power efficiency
    ];
  };
  powerManagement.cpuFreqGovernor = "schedutil"; # Balance between power and performance
  hardware.cpu.amd.updateMicrocode = true;

  # Network Optimization
  # Enable UDP Generic Receive Offload (GRO) forwarding.
  # This is critical for maximizing throughput on Tailscale VPN connections.
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
