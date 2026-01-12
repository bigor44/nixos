{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.bigor.features.cpu-power-management;

  # Auto-detect CPU vendor
  hasAMD = config.hardware.cpu.amd.updateMicrocode or false;
  hasIntel = config.hardware.cpu.intel.updateMicrocode or false;

  # Determine if this is a desktop workstation (has desktop features)
  isDesktop =
    config.bigor.features.desktop.enable or false || config.bigor.profiles.workstation.enable or false;
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

    # Power profiles daemon for desktops (allows runtime switching)
    (mkIf (hasAMD || hasIntel) {
      services.power-profiles-daemon.enable = mkIf isDesktop true;
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
