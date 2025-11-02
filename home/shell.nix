{
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "exa -l";
      la = "exa -lah";
      edit = "sudo -e";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos";
      nfu = "nix flake update";
      nfc = "nix flake check";
    };
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
