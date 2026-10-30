{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
        set -gx LESS_TERMCAP_mb \e'[1;32m'
        set -gx LESS_TERMCAP_md \e'[1;32m'
        set -gx LESS_TERMCAP_me \e'[0m'
        set -gx LESS_TERMCAP_se \e'[0m'
        set -gx LESS_TERMCAP_so \e'[01;33m'
        set -gx LESS_TERMCAP_ue \e'[0m'
        set -gx LESS_TERMCAP_us \e'[1;4;31m'
      '';
      shellAliases = {
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        eza = "eza --icons auto --git";
        ls = "eza";
        ll = "eza -l";
        la = "eza -a";
        lt = "eza --tree";
        tree = "eza --tree";
        lla = "eza -la";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
      shellAbbrs = {
        meminfo = "free -h";
        diskinfo = "df -h";
      };
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };
    fzf.keybindings = true;
    zoxide.enable = true;
    bat.enable = true;
  };
  environment.systemPackages = [ pkgs.eza ];
}
