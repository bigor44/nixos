/*
Title: Kubernetes Configuration
Description: Configures a Kubernetes cluster with different roles (control-plane or worker) for each host.
This module supports both single-node and multi-node cluster setups.
*/
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kubernetes;
in {
  options.kubernetes = {
    enable = lib.mkEnableOption "Enable Kubernetes cluster";

    role = lib.mkOption {
      type = lib.types.enum ["control-plane" "worker" "single-node"];
      default = "single-node";
      description = "Role of this node in the Kubernetes cluster";
    };

    clusterName = lib.mkOption {
      type = lib.types.str;
      default = "nixos-cluster";
      description = "Name of the Kubernetes cluster";
    };

    apiServerAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "API server address for the control plane";
    };

    podSubnet = lib.mkOption {
      type = lib.types.str;
      default = "10.244.0.0/16";
      description = "Pod network CIDR";
    };

    serviceSubnet = lib.mkOption {
      type = lib.types.str;
      default = "10.96.0.0/12";
      description = "Service network CIDR";
    };

    enableMetricsServer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Kubernetes metrics server";
    };

    enableDashboard = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Kubernetes dashboard";
    };

    cni = lib.mkOption {
      type = lib.types.enum ["flannel" "calico" "cilium"];
      default = "flannel";
      description = "Container Network Interface to use";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable container runtime (containerd)
    virtualisation.containerd = {
      enable = true;
      settings = {
        version = 2;
        plugins."io.containerd.grpc.v1.cri" = {
          cni = {
            bin_dir = "/opt/cni/bin";
            conf_dir = "/etc/cni/net.d";
          };
          containerd = {
            default_runtime_name = "runc";
            runtimes.runc = {
              runtime_type = "io.containerd.runc.v2";
              options.SystemdCgroup = true;
            };
          };
        };
      };
    };

    # Kubernetes packages
    environment.systemPackages = with pkgs; [
      kubernetes
      kubectl
      kubernetes-helm
      k9s
      kubectx
      stern
    ];

    # Kernel modules required for Kubernetes
    boot.kernelModules = ["br_netfilter" "overlay"];

    # Sysctl settings required for Kubernetes
    boot.kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = lib.mkDefault 1;
      "net.bridge.bridge-nf-call-ip6tables" = lib.mkDefault 1;
      "net.ipv4.ip_forward" = lib.mkDefault 1;
    };

    # Firewall rules
    networking.firewall.allowedTCPPorts = lib.mkMerge [
      # Common ports for all k8s nodes
      [10250 10255]

      # Control plane specific ports
      (lib.mkIf (cfg.role == "control-plane" || cfg.role == "single-node") [
        6443 # Kubernetes API server
        2379 # etcd client
        2380 # etcd peer
        10257 # kube-controller-manager
        10259 # kube-scheduler
      ])
    ];

    networking.firewall.allowedUDPPorts = [
      8285 # Flannel UDP
      8472 # Flannel VXLAN
    ];

    networking.firewall.trustedInterfaces = ["cni0" "flannel.1"];

    # Kubernetes services configuration
    services.kubernetes = {
      roles =
        if cfg.role == "control-plane"
        then ["master"]
        else if cfg.role == "worker"
        then ["node"]
        else ["master" "node"]; # single-node

      masterAddress = cfg.apiServerAddress;
      clusterCidr = cfg.podSubnet;

      # API Server configuration
      apiserver = lib.mkIf (cfg.role == "control-plane" || cfg.role == "single-node") {
        enable = true;
        advertiseAddress = cfg.apiServerAddress;
        bindAddress = "0.0.0.0";
        serviceClusterIpRange = cfg.serviceSubnet;
        securePort = 6443;
        extraOpts = ''
          --allow-privileged=true
          --authorization-mode=Node,RBAC
          --enable-admission-plugins=NodeRestriction
        '';
      };

      # Controller Manager configuration
      controllerManager = lib.mkIf (cfg.role == "control-plane" || cfg.role == "single-node") {
        enable = true;
        extraOpts = ''
          --bind-address=0.0.0.0
          --cluster-cidr=${cfg.podSubnet}
          --service-cluster-ip-range=${cfg.serviceSubnet}
          --allocate-node-cidrs=true
        '';
      };

      # Scheduler configuration
      scheduler = lib.mkIf (cfg.role == "control-plane" || cfg.role == "single-node") {
        enable = true;
        extraOpts = "--bind-address=0.0.0.0";
      };

      # Kubelet configuration (all nodes)
      kubelet = {
        enable = true;
        extraOpts = ''
          --container-runtime=remote
          --container-runtime-endpoint=unix:///run/containerd/containerd.sock
          --cgroup-driver=systemd
          --network-plugin=cni
          --cni-conf-dir=/etc/cni/net.d
          --cni-bin-dir=/opt/cni/bin
        '';
      };

      # Kube-proxy configuration (all nodes)
      proxy = {
        enable = true;
        extraOpts = "--cluster-cidr=${cfg.podSubnet}";
      };

      # Easy RBAC for development
      easyCerts = true;
    };

    # Systemd service for initial cluster setup (control-plane/single-node only)
    systemd.services.kubernetes-init = lib.mkIf (cfg.role == "control-plane" || cfg.role == "single-node") {
      description = "Initialize Kubernetes cluster";
      wantedBy = ["multi-user.target"];
      after = ["network.target" "containerd.service" "kube-apiserver.service"];
      path = with pkgs; [kubernetes kubectl];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        # Wait for API server to be ready
        for i in {1..60}; do
          if kubectl get nodes 2>/dev/null; then
            break
          fi
          echo "Waiting for Kubernetes API server... ($i/60)"
          sleep 5
        done

        # Label the node
        kubectl label node $(hostname) node-role.kubernetes.io/${cfg.role}=true --overwrite || true

        ${lib.optionalString cfg.enableMetricsServer ''
          # Install metrics-server if not already installed
          if ! kubectl get deployment metrics-server -n kube-system &>/dev/null; then
            kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
            # Patch metrics-server for self-signed certificates
            kubectl patch deployment metrics-server -n kube-system --type='json' \
              -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' || true
          fi
        ''}

        ${lib.optionalString cfg.enableDashboard ''
          # Install Kubernetes dashboard if not already installed
          if ! kubectl get deployment kubernetes-dashboard -n kubernetes-dashboard &>/dev/null; then
            kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml || true
          fi
        ''}
      '';
    };

    # Create kubectl config directory and setup for user
    systemd.tmpfiles.rules = [
      "d /home/bigor/.kube 0755 bigor users"
      "L+ /home/bigor/.kube/config - - - - /etc/kubernetes/cluster-admin.kubeconfig"
    ];

    # Environment variables
    environment.variables = {
      KUBECONFIG = "/etc/kubernetes/cluster-admin.kubeconfig";
    };
  };
}
