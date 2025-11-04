{pkgs, ...}: let
  sharedAliases = {
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
in {
  home.username = "bigor";
  home.homeDirectory = "/home/bigor";
  home.stateVersion = "25.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
    eza
    gemini-cli
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
    shellAliases = sharedAliases;
  };
  programs.zsh = {
    enable = true;
    shellAliases = sharedAliases;
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
