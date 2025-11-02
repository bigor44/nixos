{pkgs, ...}: {
  home.username = "bigor";
  home.homeDirectory = "/home/bigor";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
  ];
  programs.git = {
    enable = true;
    settings.user = {
      name = "Yoann Bigor";
      email = "bigor44@gmail.com";
    };
  };
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
  programs.fish = {
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
    shellAbbrs = {
      gaa = "git add -A";
      gc = "git commit";
      gcm = "git commit -m";
      gd = "git diff";
      gl = "git pull";
      gp = "git push";
      gst = "git status";
    };
  };
}
