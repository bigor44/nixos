{ ... }: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./desktop-env.nix
    ./packages.nix
    ./flatpak.nix
  ];
}
