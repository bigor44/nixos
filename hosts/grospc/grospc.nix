{ pkgs, ... }:
{
  networking.hostName = "grospc";
  desktop.enable = true;
  server.enable = false;
  adblocker.enable = true;
  nfs.client.enable = true;

  # Gaming optimizations
  programs.gamemode.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD GPU optimizations
  boot.kernelParams = [ "amd_pstate=active" ];
  hardware.amdgpu.opencl.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
}
