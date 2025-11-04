{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "exa -l";
      la = "exa -lah";
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
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "exa -l";
      la = "exa -lah";
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
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "zoxide"
        "fzf"
      ];
      theme = "dst";
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
    enableBashIntegration = true;
  };
}
