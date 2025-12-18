{
  # ============================================================================
  # File: modules/nixos/features/system/boot/default.nix
  # Description: Configures the systemd-boot bootloader.
  # Author: Bigor
  # Date: 2025-12-18
  # ============================================================================

  # ============================================================================
  # Bootloader Configuration
  # ============================================================================
  # We use systemd-boot as it is simple, reliable, and well-integrated with UEFI.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Keep the boot menu clean
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
