# Feature: cpu-power-management
# Purpose: CPU frequency scaling and power optimizations (AMD P-State / Intel P-State)
{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.bigor.features.cpu-power-management;

  # Auto-detect CPU vendor
  hasAMD = config.hardware.cpu.amd.updateMicrocode or false;
  hasIntel = config.hardware.cpu.intel.updateMicrocode or false;
in
{
  options.bigor.features.cpu-power-management = {
    enable = mkEnableOption "CPU power management with P-State support";
  };

  config = mkIf cfg.enable (mkMerge [
    # AMD P-State configuration
    (mkIf hasAMD {
      boot.kernelParams = [ "amd_pstate=active" ];
    })

    # Intel P-State configuration
    (mkIf hasIntel {
      boot.kernelParams = [ "intel_pstate=active" ];
    })

    # Power profiles daemon for runtime switching between power/balanced/performance
    (mkIf (hasAMD || hasIntel) {
      services.power-profiles-daemon.enable = true;
    })

    # Assertions
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
