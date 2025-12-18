{
  config,
  pkgs,
  ...
}:
{
  # ============================================================================
  # File: systems/x86_64-linux/minipc/default.nix
  # Description: Host-specific configuration for "minipc"
  # Author: Bigor
  # Date: 2025-12-15
  # Purpose: Defines the home lab server environment, including headless services,
  #          NFS storage hosting, and network optimizations.
  # ============================================================================

  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "minipc";
  system.stateVersion = "25.05";

  # ============================================================================
  # Custom Role & Feature Flags
  # ============================================================================
  # - Headless Server (roles.homelab_master)
  # - NFS Server for centralized storage
  # - Tailscale Exit Node/Relay with UDP GRO optimization
  # - Ollama AI Service
  bigor = {
    profiles.homelab-master.enable = true;
    network.mainInterface = "enp2s0";

    lib.exposedService = {
      minipc = {
        domain = "minipc.bigor.lan";
        port = 0; # Dummy port, as we only need the DNS entry
      };
      bigor = {
        domain = "bigor.lan";
        port = 0; # Dummy port, as we only need the DNS entry
      };
    };
  };

  # ============================================================================
  # Kernel & Power Management
  # ============================================================================
  # Use the standard kernel for stability on the server.
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "amd_pstate=active" # Enable AMD P-State driver for better power efficiency
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  # ============================================================================
  # Network Optimization
  # ============================================================================
  # Enable UDP Generic Receive Offload (GRO) forwarding.
  # Critical for maximizing throughput on Tailscale VPN connections.
  systemd.services.network-udp-gro = {
    description = "Enable UDP GRO forwarding for Tailscale";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K ${config.bigor.network.mainInterface} rx-udp-gro-forwarding on rx-gro-list on";
      SuccessExitStatus = "0 1";
    };
  };
}
