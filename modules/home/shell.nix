{ pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;

      # Fish Plugins
      plugins = [
        {
          name = "bobthefisher"; # Theme
          inherit (pkgs.fishPlugins.bobthefisher) src;
        }
        {
          name = "autopair"; # Auto-close quotes and brackets
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "colored-man-pages";
          inherit (pkgs.fishPlugins.colored-man-pages) src;
        }
      ];

      # Aliases
      shellAliases = {
        # Enhanced ls with eza
        ll = "eza -l --icons --git";
        la = "eza -lah --icons --git";
        lt = "eza --tree --level=2 --icons";

        # Safety nets
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";

        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };

      # Abbreviations (expand on space)
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

      # Interactive Shell Initialization
      interactiveShellInit = ''
        # Initialize nh (Nix Helper) if available
        if test -f ${pkgs.nh}/share/fish/vendor_conf.d/nh.fish
          source ${pkgs.nh}/share/fish/vendor_conf.d/nh.fish
        end

        # Nix flake completions
        source ${pkgs.nix}/share/fish/vendor_completions.d/nix.fish

        # Disable welcome message
        set fish_greeting

        # Theme configuration (Bobthefisher)
        set -gx EZA_COLORS "da=38;5;240:gm=38;5;240"
      '';
    };

    # Fuzzy Finder
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

    # Smarter 'cd'
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    # Better 'cat'
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };
  };
}
