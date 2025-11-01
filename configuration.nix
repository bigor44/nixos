{config, ...}: {
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
    ./modules/neovim.nix
    # Optionnal Modules
    ./modules/audio.nix
    ./modules/adguard.nix
    ./modules/desktop-env.nix
    ./modules/bluetooth.nix
    ./modules/desktop-apps.nix
    ./modules/flatpak.nix
    ./modules/ssh.nix
    ./modules/monitoring.nix
    ./modules/podman.nix
    ./modules/podman-home-assistant.nix
    ./modules/dashboard.nix
  ];

  config = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    system.stateVersion = "25.05";
  };
}
