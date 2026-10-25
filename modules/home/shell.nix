# Home: shell
# Purpose: Fish shell, Starship, and CLI tools (eza, fzf, zoxide, bat, rsync)
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

      shellAliases = {
        # Safety
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";

        # Directory shortcuts
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";

        # Nix
        nfu = "nix flake update";
        nclean = "nh clean all";

        # Quality Assurance
        # flake check also runs the formatters and linters
        qf = "nix flake check";

        # Safe Workflows
        gcn = "git add -A && nix fmt && git commit";
        gps = "nix flake check && gp";
        nrs = "nix flake check ~/nixos && nh os switch";
        nrb = "nix flake check ~/nixos && nh os boot";

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

    # Modules instead of bare packages for the fish integrations (eza's ls/ll/la/lt aliases, fzf keybindings, zoxide's z)
    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };
    fzf.enable = true;
    zoxide.enable = true;
    bat.enable = true;
  };

  home.packages = [ pkgs.rsync ];

  home.sessionVariables = {
    PAGER = "less";
    LESS = "-R";
  };
}
