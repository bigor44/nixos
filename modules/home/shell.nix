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

      functions = {
        gai = ''
          set diff (git diff --cached)
          if test -z "$diff"
              echo "No staged changes to commit."
              return 1
          end

          echo "Generating commit message..."
          set msg (echo "$diff" | gemini "Generate a concise, conventional commit message for this diff. Return ONLY the raw message text, no markdown, no quotes.")

          if test -z "$msg"
              echo "Failed to generate message."
              return 1
          end

          echo "----------------------------------------------------------------"
          echo "$msg"
          echo "----------------------------------------------------------------"

          read -l -P "Commit with this message? [y/N] " confirm
          if test "$confirm" = "y"
              git commit -m "$msg"
          else
              echo "Commit cancelled."
          end
        '';
      };

      interactiveShellInit = ''
        if test -f ${pkgs.nh}/share/fish/vendor_conf.d/nh.fish
          source ${pkgs.nh}/share/fish/vendor_conf.d/nh.fish
        end

        source ${pkgs.nix}/share/fish/vendor_completions.d/nix.fish

        set fish_greeting

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

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };
  };
}
