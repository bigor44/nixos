# Platform: gpu
# Purpose: AMD GPU compute (Vulkan via RADV, ROCm/HIP + OpenCL) for local LLM runtimes like ollama/llama.cpp
{ pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.opencl.enable = true;
  };

  # Many ROCm builds hardcode /opt/rocm; expose the Nix HIP runtime there
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];

  # /dev/kfd and /dev/dri/renderD* are group-restricted
  users.users.bigor.extraGroups = [
    "render"
    "video"
  ];

  environment.systemPackages = with pkgs; [
    amdgpu_top
    clinfo
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    vulkan-tools
  ];
}
