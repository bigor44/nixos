{pkgs, ...}: {
  # ============================================================================
  # Shell Environment (Fish)
  # ============================================================================
  # Configures Fish shell with plugins, aliases, and abbreviations.
  # Integrates:
  # - Starship (prompt) - implicitly via bobthefisher or separate module?
  # - fzf (fuzzy finder)
  # - zoxide (directory jumping)
  # - bat (enhanced cat)
  # ============================================================================
  programs = {
    fish = {
      enable = true;

      plugins = [
        {
          name = "Tide";
          inherit (pkgs.fishPlugins.tide) src;
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "colored-man-pages";
          inherit (pkgs.fishPlugins.colored-man-pages) src;
        }
      ];

      shellAliases = {
        ll = "eza -l --icons --git";
        la = "eza -lah --icons --git";
        lt = "eza --tree --level=2 --icons";

        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };

      shellAbbrs = {
        # Nix flake operations
        nfc = "nix flake check";
        nfu = "nix flake update";

        # Git shortcuts
        gaa = "git add -A";
        gc = "git commit";
        gcm = "git commit -m";
        gca = "git commit --amend";
        gd = "git diff";
        gds = "git diff --staged";
        gl = "git pull";
        gp = "git push";
        gpf = "git push --force-with-lease";
        gst = "git status";
        gco = "git checkout";
        gcb = "git checkout -b";
        gb = "git branch";
        glog = "git log --oneline --graph --decorate";

        # System monitoring
        ports = "netstat -tulanp";
        meminfo = "free -h";
        diskinfo = "df -h";
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--inline-info"
      ];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = ["--cmd cd"];
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };
  };
}
