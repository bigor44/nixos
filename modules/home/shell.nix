/*
  Title: Shell Configuration
  Description: Configures Bash and Zsh with aliases, plugins, and other settings.
*/
{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -l";
      la = "eza -lah";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos";
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
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "bobthefisher";
        src = pkgs.fishPlugins.bobthefisher.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
    ];
    shellAliases = {
      ll = "eza -l";
      la = "eza -lah";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos";
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
    enableBashIntegration = true;
  };
}
