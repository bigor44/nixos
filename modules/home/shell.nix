/*
  Title: Shell Configuration
  Description: Configures Bash and Zsh with aliases, plugins, and other settings.
*/
{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "bobthefisher";
        src = pkgs.fishPlugins.bobthefisher.src;
      }
    ];
    shellAliases = {
      ll = "eza -l";
      la = "eza -lah";
    };
    shellAbbrs = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos";
      ncg = "sudo nix-collect-garbage -d";
      nfu = "nix flake update";
      nfc = "nix flake check";
      gaa = "git add -A";
      gc = "git commit";
      gcm = "git commit -m";
      gd = "git diff";
      gl = "git pull";
      gp = "git push";
      gst = "git status";
    };
  };
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
