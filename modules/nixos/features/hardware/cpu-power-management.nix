# Feature: hardware-cpu-power-management
# Purpose: CPU frequency scaling and power optimizations (AMD P-State / Intel P-State)
{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.bigor.features.hardware.cpu-power-management;

  # Auto-detect CPU vendor
  hasAMD = config.hardware.cpu.amd.updateMicrocode or false;
  hasIntel = config.hardware.cpu.intel.updateMicrocode or false;
in
{
  options.bigor.features.hardware.cpu-power-management = {
    enable = mkEnableOption "CPU power management with P-State support";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf hasAMD {
      boot.kernelParams = [ "amd_pstate=active" ];
    })

    (mkIf hasIntel {
      boot.kernelParams = [ "intel_pstate=active" ];
    })

    # Power profiles daemon for runtime switching between power/balanced/performance
    (mkIf (hasAMD || hasIntel) {
      services.power-profiles-daemon.enable = true;
    })

    {
      assertions = [
        {
          assertion = cfg.enable -> (hasAMD || hasIntel);
          message = "cpu-power-management requires either AMD or Intel CPU microcode updates to be enabled";
        }
      ];
    }
  ]);
}
