# Module: features.shell.zsh
# Purpose: Zsh shell configuration with aliases
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.home.features.shell;
in
{
  config = mkIf cfg.enable {
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

        # System info
        ports = "netstat -tulanp";
        meminfo = "free -h";
        diskinfo = "df -h";
      };
    };
  };
}
