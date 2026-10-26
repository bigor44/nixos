# Platform: core
# Purpose: Boot, firmware updates, Nix settings, caches, primary user and Home Manager
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
      trusted-users = [
        "root"
        "bigor"
      ];

      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage collection is handled by programs.nh.clean (packages.nix)
    optimise.automatic = true;
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
