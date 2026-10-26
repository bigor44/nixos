# Platform: core
# Purpose: Boot, firmware updates, Nix settings, primary user and Home Manager
{ pkgs, ... }:
{
  # --- Boot Configuration ---
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  # Firmware updates (UEFI, NVMe, peripherals) via LVFS: `fwupdmgr refresh && fwupdmgr update`
  services.fwupd.enable = true;

  # --- Nix Core Configuration ---
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Hardlink duplicates at build time; garbage collection is handled by programs.nh.clean (packages.nix)
      auto-optimise-store = true;
    };
  };

  # --- User ---
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  security.sudo.wheelNeedsPassword = false;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Rename pre-existing files (e.g. a pre-existing ~/.config/fish/config.fish) instead of aborting activation
    backupFileExtension = "hm-backup";
    users.bigor = import ../home;
  };
}
