{pkgs, ...}: {
  programs = {
    fish = {
      enable = true;

      plugins = [
        {
          name = "bobthefisher";
          inherit (pkgs.fishPlugins.bobthefisher) src;
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "colored-man-pages";
          inherit (pkgs.fishPlugins.colored-man-pages) src;
        }
        {
          name = "done";
          inherit (pkgs.fishPlugins.done) src;
        }
      ];

      shellAliases = {
        # Enhanced ls with eza
        ll = "eza -l --icons --git";
        la = "eza -lah --icons --git";
        lt = "eza --tree --level=2 --icons";

        # Common shortcuts
        cat = "bat";
        grep = "rg";

        # Safety nets
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";

        # Quick navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };

      shellAbbrs = {
        #Nix flake operations
        nfc = "nix flake check";
        nfu = "nix flake update";

        # Git operations
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

      # Additional fish configuration
      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting

        # Set colors for eza
        set -gx EZA_COLORS "da=38;5;240:gm=38;5;240"
      '';
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

    # Bat configuration
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
        pager = "less -FR";
      };
    };
  };
}
