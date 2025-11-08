# This is the main configuration file for the NixOS system.
# It imports other modules and sets system-wide options.
{config, ...}: {
  imports = [
    # Base Modules
    ./modules/nixos/options.nix
    ./modules/nixos/boot.nix
    ./modules/nixos/gc.nix
    ./modules/nixos/locale.nix
    ./modules/nixos/network.nix
    ./modules/nixos/base-apps.nix
    ./modules/nixos/users.nix
    ./modules/nixos/fonts.nix
    ./modules/nixos/neovim.nix
    ./modules/nixos/ssh.nix

    # Optionnal Modules

    ./modules/nixos/audio.nix
    ./modules/nixos/adguard.nix
    ./modules/nixos/desktop-env.nix
    ./modules/nixos/bluetooth.nix
    ./modules/nixos/desktop-apps.nix
    ./modules/nixos/flatpak.nix
    ./modules/nixos/monitoring.nix
    ./modules/nixos/ollama.nix
  ];

  config = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    system.stateVersion = "25.05";
  };
}
