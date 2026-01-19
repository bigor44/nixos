# Platform: shell
# Purpose: Zsh shell, Starship, and CLI tools
{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
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
      qc = "check-quick";
      qs = "check-quick --staged";
      qf = "check-full";
      mega = "check-mega";

      # Safe Workflows
      gcn = "nix fmt && gaa && qs && gc";
      gps = "check-full && gp";
      nrs = "check-full && sudo nixos-rebuild switch --flake .";
      nrb = "check-full && sudo nixos-rebuild boot --flake .";

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

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
  };

  # CLI Tools
  environment.systemPackages = with pkgs; [
    eza
    fzf
    zoxide
    bat
    fd
    ripgrep
  ];
}
