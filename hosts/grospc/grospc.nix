{ pkgs, ... }:
{
  networking.hostName = "grospc";
  desktop.enable = true;
  server.enable = false;
  adblocker.enable = true;
  nfs.client.enable = true;

  # Gaming optimizations
  programs.gamemode.enable = true;

  # AMD GPU optimizations
  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.ppfeaturemask=0xffffffff" # Unlock all GPU features
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };

  hardware.amdgpu = {
    opencl.enable = true;
    overdrive.enable = true;
  };

  # Performance governor for gaming
  powerManagement.cpuFreqGovernor = "performance";

  # Steam library optimization
  fileSystems."/steamlibrary".options = [
    "noatime"
    "nodiratime"
  ];
}
