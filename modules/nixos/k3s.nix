/*
Title: K3s Cluster Configuration
Description: Configures a k3s cluster with minipc as master and grospc as worker node.
*/
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.k3s;
  isMaster = config.networking.hostName == "minipc";
  isWorker = config.networking.hostName == "grospc";
in {
  options.k3s = {
    enable = lib.mkEnableOption "Enable k3s cluster";

    tokenFile = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/rancher/k3s/server/node-token";
      description = "Path to the k3s cluster token file";
    };

    masterAddress = lib.mkOption {
      type = lib.types.str;
      default = "https://minipc.lan:6443";
      description = "Address of the k3s master node";
    };

    extraServerArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arguments to pass to k3s server";
    };

    extraAgentArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Extra arguments to pass to k3s agent";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install k3s package and helper scripts
    environment.systemPackages = with pkgs;
      [
        k3s
      ]
      ++ lib.optionals isMaster [
        # Helper script on master to display the token
        (pkgs.writeScriptBin "k3s-token" ''
          #!${pkgs.bash}/bin/bash
          if [ -f /var/lib/rancher/k3s/server/node-token ]; then
            cat /var/lib/rancher/k3s/server/node-token
          else
            echo "Token file not found. Is k3s running?"
            exit 1
          fi
        '')
      ];

    # K3s service configuration (works for both master and worker)
    services.k3s = {
      enable = true;
      role =
        if isMaster
        then "server"
        else "agent";
      serverAddr = lib.mkIf isWorker cfg.masterAddress;
      tokenFile = lib.mkIf isWorker cfg.tokenFile;
      extraFlags = lib.concatStringsSep " " (
        if isMaster
        then
          [
            "--tls-san minipc.lan"
            "--tls-san minipc"
            "--write-kubeconfig-mode 644"
          ]
          ++ cfg.extraServerArgs
        else cfg.extraAgentArgs
      );
    };

    # Firewall configuration (common + role-specific ports)
    networking.firewall = {
      allowedTCPPorts =
        [
          10250 # Kubelet metrics (both master and worker)
        ]
        ++ lib.optionals isMaster [
          6443 # Kubernetes API (master only)
        ];
      allowedUDPPorts = [
        8472 # Flannel VXLAN (both master and worker)
      ];
    };

    # Add kubectl alias for easier access on master
    environment.shellAliases = lib.mkIf isMaster {
      kubectl = "k3s kubectl";
      k = "k3s kubectl";
    };
  };
}
