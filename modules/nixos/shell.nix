# Platform: shell
# Purpose: Fish as the interactive shell, with Starship, eza, fzf, zoxide, bat and generic aliases
{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      # Disables the greeting, then colors man pages through less's termcap overrides
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
      # Aliases, not abbreviations, where a standard command is silently replaced
      shellAliases = {
        # Prompt before overwriting or deleting
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        # Defining eza itself first means ls/ll/… inherit icons and git status
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
      # Nix abbreviations are in core.nix, git ones in dev.nix
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
    # Program modules rather than plain packages: they also wire up the fish integration
    fzf.keybindings = true;
    zoxide.enable = true;
    bat.enable = true;
  };
  # No NixOS eza module exists, hence the package plus the aliases above
  environment.systemPackages = [ pkgs.eza ];
}
