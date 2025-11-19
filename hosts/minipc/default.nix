{pkgs, ...}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "minipc";
  adblocker.enable = true;
  sshd.enable = true;
  desktop.enable = false;

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
