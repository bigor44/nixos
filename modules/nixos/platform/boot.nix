# Platform: system.boot
# Purpose: systemd-boot UEFI bootloader configuration
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };
}
