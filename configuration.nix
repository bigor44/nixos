{ config, lib, pkgs, ... }:

{
  imports = [
    # Base Modules
    ./modules/options.nix
    ./modules/boot.nix
    ./modules/gc.nix
    ./modules/locale.nix
    ./modules/network.nix
    ./modules/base-apps.nix
    ./modules/users.nix
    ./modules/fonts.nix
     # Optionnal Modules
    ./modules/audio.nix
    ./modules/adguard.nix
    ./modules/desktop-env.nix
    ./modules/bluetooth.nix
    ./modules/desktop-apps.nix
    ./modules/flatpak.nix
    ./modules/ssh.nix
  ];

  config = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    system.stateVersion = "25.05";
  };
}
