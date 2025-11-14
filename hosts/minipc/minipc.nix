{
  networking.hostName = "minipc";
  desktop.enable = false;
  server.enable = true;
  adblocker.enable = true;
  nfs.server.enable = true;

  boot.kernelParams = [
    "amd_pstate=active"
    "processor.max_cstate=1" # Better for 24/7 server
  ];
  powerManagement.cpuFreqGovernor = "schedutil";
  hardware.cpu.amd.updateMicrocode = true;
}
