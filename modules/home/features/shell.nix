# Module: features.shell
# Purpose: Zsh shell with Starship prompt, fzf, zoxide, and bat
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.bigor.home.features.shell;
in
{
  options.bigor.home.features.shell.enable = mkEnableOption "Shell configuration";

  config = mkIf cfg.enable {
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
          # Navigation
          ll = "eza -l --icons --git";
          la = "eza -lah --icons --git";
          lt = "eza --tree --level=2 --icons";
          tree = "eza --tree";

          # Safety
          rm = "rm -i";
          cp = "cp -i";
          mv = "mv -i";

          # Directory shortcuts
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";

          # Nix
          nfc = "nix flake check";
          nfu = "nix flake update";

          # System info
          ports = "netstat -tulanp";
          meminfo = "free -h";
          diskinfo = "df -h";
        };
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;

          # Catppuccin Mocha palette
          palette = "catppuccin_mocha";
          palettes.catppuccin_mocha = {
            rosewater = "#f5e0dc";
            flamingo = "#f2cdcd";
            pink = "#f5c2e7";
            mauve = "#cba6f7";
            red = "#f38ba8";
            maroon = "#eba0ac";
            peach = "#fab387";
            yellow = "#f9e2af";
            green = "#a6e3a1";
            teal = "#94e2d5";
            sky = "#89dceb";
            sapphire = "#74c7ec";
            blue = "#89b4fa";
            lavender = "#b4befe";
            text = "#cdd6f4";
            subtext1 = "#bac2de";
            subtext0 = "#a6adc8";
            overlay2 = "#9399b2";
            overlay1 = "#7f849c";
            overlay0 = "#6c7086";
            surface2 = "#585b70";
            surface1 = "#45475a";
            surface0 = "#313244";
            base = "#1e1e2e";
            mantle = "#181825";
            crust = "#11111b";
          };

          character = {
            success_symbol = "[❯](green)";
            error_symbol = "[❯](red)";
          };

          directory = {
            style = "sapphire";
            truncation_length = 3;
            truncate_to_repo = true;
          };

          git_branch = {
            style = "mauve";
          };

          git_status = {
            style = "maroon";
            conflicted = "[≠](red)";
            ahead = "[⇡](green)";
            behind = "[⇣](peach)";
            diverged = "[⇕](red)";
            untracked = "[?](teal)";
            stashed = "[$](lavender)";
            modified = "[!](yellow)";
            staged = "[+](green)";
          };

          cmd_duration = {
            min_time = 3000;
            style = "overlay1";
          };

          time = {
            disabled = false;
            format = "[$time]($style) ";
            style = "subtext0";
            time_format = "%H:%M";
          };

          status = {
            disabled = false;
            symbol = "✘ ";
            success_symbol = "";
            style = "red";
          };
        };
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
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
        enableZshIntegration = true;
        options = [ "--cmd cd" ];
      };

      bat = {
        enable = true;
        config.pager = "less -FR";
      };
    };
  };
}
