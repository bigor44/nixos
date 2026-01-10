{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.bigor.policies.power;
in
{
  options.bigor.policies.power = mkOption {
    type = types.enum [
      "amd-pstate"
      "intel-pstate"
      "performance"
      "balanced"
      "powersave"
    ];
    default = "balanced";
    description = ''
      CPU power management policy:
      - "amd-pstate": AMD P-State EPP active mode
      - "intel-pstate": Intel P-State active mode
      - "performance": Maximum performance
      - "balanced": Default kernel behavior
      - "powersave": Maximum power saving
    '';
  };

  config.boot.kernelParams =
    {
      amd-pstate = [ "amd_pstate=active" ];
      intel-pstate = [ "intel_pstate=active" ];
      performance = [ "cpufreq.default_governor=performance" ];
      balanced = [ ];
      powersave = [ "cpufreq.default_governor=powersave" ];
    }
    .${cfg};
}
