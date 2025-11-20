{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.llm.enable {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.0";
  };

  systemd.services.ollama = {
    # On force l'appartenance aux groupes matériels
    serviceConfig = {
      SupplementaryGroups = ["video" "render"];

      # Variables d'environnement (toujours nécessaires)
      Environment = [
        "HSA_OVERRIDE_GFX_VERSION=11.0.0"
        "HIP_VISIBLE_DEVICES=0" # Cible la 7800 XT
        "HSA_ENABLE_SDMA=0"
      ];
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
  ];
}
