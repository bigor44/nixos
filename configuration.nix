{ config, ... }:
{
  imports = [
    # Core system modules
    ./modules/nixos/options.nix
    ./modules/nixos/system.nix
    ./modules/nixos/network.nix
    ./modules/nixos/users.nix
    ./modules/nixos/packages.nix
    ./modules/nixos/nixvim.nix

    # Optional service modules
    ./modules/nixos/desktop.nix
    ./modules/nixos/adguard.nix
    ./modules/nixos/sshd.nix
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
