{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "fzf" "sudo" ];
      theme = "agnoster";
    };
    shellAliases = {
      ll = "exa -l";
      la = "exa -lah";
      edit = "sudo -e";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos";
      nrb = "sudo nixos-rebuild boot --flake ~/nixos";
      nfu = "nix flake update";
      nfc = "nix flake check";
    };
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];
  }; 
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = { 
    enable = true;
    enableZshIntegration = true;
  };
}
