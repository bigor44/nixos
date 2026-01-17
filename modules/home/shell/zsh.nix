# Module: shell.zsh
# Purpose: Zsh shell configuration with aliases
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
      qc = "check-quick"; # Quick check: changed files
      qs = "check-quick --staged"; # Quick check: staged files
      qf = "check-full"; # Full check: everything
      mega = "check-mega"; # Intelligent orchestration

      # Safe Workflows
      gcn = "nix fmt && gaa && qs && gc"; # Safe commit
      gps = "check-full && gp"; # Safe push
      nrs = "check-full && sudo nixos-rebuild switch --flake ."; # Safe rebuild
      nrb = "check-full && sudo nixos-rebuild boot --flake ."; # Safe rebuild (boot)

      # System info
      ports = "netstat -tulanp";
      meminfo = "free -h";
      diskinfo = "df -h";
    };
  };
}
