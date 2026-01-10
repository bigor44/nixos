{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    mkIf
    mkMerge
    types
    ;
  cfg = config.bigor.policies.power;

  # Determine if we should use power-profiles-daemon (for P-State modes)
  usePowerProfilesDaemon = cfg == "amd-pstate" || cfg == "intel-pstate";

  # CPU frequency governor (for static governor modes)
  cpuFreqGovernor =
    {
      performance = "performance";
      powersave = "powersave";
      balanced = null;
      amd-pstate = null; # Managed by power-profiles-daemon
      intel-pstate = null; # Managed by power-profiles-daemon
    }
    .${cfg};
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
      System-wide power management policy affecting kernel, CPU governor, and power profiles:

      - "amd-pstate": AMD P-State EPP active mode with power-profiles-daemon for runtime control
      - "intel-pstate": Intel P-State active mode with power-profiles-daemon for runtime control
      - "performance": Maximum performance with performance governor
      - "balanced": Default kernel behavior, no explicit governor setting
      - "powersave": Maximum power saving with powersave governor

      P-State modes enable power-profiles-daemon, allowing desktop environments (COSMIC, GNOME, KDE)
      to switch between performance/balanced/power-saver profiles at runtime.
    '';
  };

  config = mkMerge [
    # Kernel parameters for P-State and static governors
    {
      boot.kernelParams =
        {
          amd-pstate = [ "amd_pstate=active" ];
          intel-pstate = [ "intel_pstate=active" ];
          performance = [ "cpufreq.default_governor=performance" ];
          balanced = [ ];
          powersave = [ "cpufreq.default_governor=powersave" ];
        }
        .${cfg};
    }

    # CPU frequency governor (for static modes only)
    (mkIf (cpuFreqGovernor != null) {
      powerManagement.cpuFreqGovernor = cpuFreqGovernor;
    })

    # Power profiles daemon (for P-State modes with runtime control)
    (mkIf usePowerProfilesDaemon {
      services.power-profiles-daemon.enable = true;
    })
  ];
}
