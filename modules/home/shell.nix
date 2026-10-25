# Home: shell
# Purpose: Zsh shell, Starship, and CLI tools
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Colored man pages
      export LESS_TERMCAP_mb=$'\e[1;32m'
      export LESS_TERMCAP_md=$'\e[1;32m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;4;31m'
    '';

    shellAliases = {
      # Navigation
      ll = "eza -l --icons --git";
      la = "eza -lah --icons --git";
      lt = "eza --tree --level=2 --icons";
      tree = "eza --tree";

      # Safety
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";

      # Directory shortcuts
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Nix
      nfc = "nix flake check";
      nfu = "nix flake update";
      nclean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # Quality Assurance
      qc = "nix develop --command pre-commit run";
      # flake check already runs the pre-commit hooks
      qf = "nix flake check";

      # Safe Workflows
      gcn = "git add -A && nix develop --command pre-commit run && git commit";
      gps = "nix flake check && gp";
      nrs = "nix flake check ~/nixos && sudo nixos-rebuild switch --flake ~/nixos";
      nrb = "nix flake check ~/nixos && sudo nixos-rebuild boot --flake ~/nixos";

      # System info
      ports = "netstat -tulanp";
      meminfo = "free -h";
      diskinfo = "df -h";
    };
  };

  # Starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
  };

  # eza, fd and ripgrep come from the system packages
  home.packages = with pkgs; [
    fzf
    zoxide
    bat
  ];
}
