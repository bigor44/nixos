{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "minipc";

  system.role = "server";

  # NFS
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/storage 192.168.1.1(rw,sync,no_subtree_check,no_root_squash)
    '';
  };
  networking.firewall.allowedTCPPorts = [ 2049 ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=active"
      "processor.max_cstate=1" # Better for 24/7 server
    ];
  };
  powerManagement.cpuFreqGovernor = "schedutil";
  hardware.cpu.amd.updateMicrocode = true;
}
