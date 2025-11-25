{ pkgs, ... }:
{
  programs = {
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;

        # On définit la structure : Dossier > Git > Flèche finale
        # On ajoute aussi le prompt à droite (durée de la commande) typique de bobthefisher
        format = "[](mauve)$directory[](fg:mauve bg:surface0)$git_branch$git_status[](fg:surface0) ";
        right_format = "$cmd_duration";

        # Définition des couleurs Catppuccin Mocha pour l'harmonisation
        palette = "catppuccin_mocha";
        palettes.catppuccin_mocha = {
          base = "#1e1e2e";
          mantle = "#181825";
          surface0 = "#313244";
          text = "#cdd6f4";
          blue = "#89b4fa";
          mauve = "#cba6f7";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
        };

        # 1. Le Dossier (Premier bloc)
        directory = {
          style = "fg:base bg:mauve"; # Texte sombre sur fond Mauve
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          read_only = " 🔒";
        };

        # 2. Git Branch (Deuxième bloc)
        git_branch = {
          symbol = " ";
          style = "fg:text bg:surface0"; # Texte clair sur fond gris foncé
          format = "[ $symbol$branch ]($style)";
        };

        # 3. Git Status (Suite du deuxième bloc)
        git_status = {
          style = "fg:red bg:surface0";
          format = "[$all_status$ahead_behind ]($style)";
        };

        # 4. Indicateur de succès/échec (similaire aux flèches de couleur de bobthefisher)
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        # Infos de droite
        cmd_duration = {
          min_time = 500;
          format = "[$duration]($style)";
          style = "yellow";
        };
      };
    };
    fish = {
      enable = true;

      plugins = [
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
      options = [ "--cmd cd" ];
    };

    # Bat configuration
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };
  };
}
