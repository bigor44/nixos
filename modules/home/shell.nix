# Home: shell
# Purpose: Zsh shell, Starship, and CLI tools (eza, fzf, zoxide, bat)
{
  programs = {
    zsh = {
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

    # Modules instead of bare packages for the zsh integrations (eza's ls/ll/la/lt aliases, fzf keybindings, zoxide's z)
    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };
    fzf.enable = true;
    zoxide.enable = true;
    bat.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
  };
}
