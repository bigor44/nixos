# Platform: shell
# Purpose: Fish shell, Starship, CLI tools (eza, fzf, zoxide, bat) and shell aliases/abbreviations
{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        set -g fish_greeting

        # Colored man pages
        set -gx LESS_TERMCAP_mb \e'[1;32m'
        set -gx LESS_TERMCAP_md \e'[1;32m'
        set -gx LESS_TERMCAP_me \e'[0m'
        set -gx LESS_TERMCAP_se \e'[0m'
        set -gx LESS_TERMCAP_so \e'[01;33m'
        set -gx LESS_TERMCAP_ue \e'[0m'
        set -gx LESS_TERMCAP_us \e'[1;4;31m'
      '';

      # Aliases only where an existing command is redefined
      shellAliases = {
        # Safety
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";

        # eza (NixOS has no eza module; same aliases Home Manager's eza integration provided)
        eza = "eza --icons auto --git";
        ls = "eza";
        ll = "eza -l";
        la = "eza -a";
        lt = "eza --tree";
        tree = "eza --tree";
        lla = "eza -la";

        # Directory shortcuts
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };

      # Abbreviations expand in place, so the full command lands in history and stays editable
      # Nix workflow abbreviations live in core.nix, git ones in dev.nix
      shellAbbrs = {
        # System info
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

    # Modules instead of bare packages for the fish integrations (fzf keybindings, zoxide's z)
    fzf.keybindings = true;
    zoxide.enable = true;
    bat.enable = true;
  };

  environment.systemPackages = [ pkgs.eza ];
}
