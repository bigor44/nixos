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
          # Catppuccin Powerline preset
          format = lib.concatStrings [
            "[](red)"
            "$os"
            "$username"
            "[](bg:peach fg:red)"
            "$directory"
            "[](bg:yellow fg:peach)"
            "$git_branch"
            "$git_status"
            "[](fg:yellow bg:green)"
            "$c"
            "$rust"
            "$golang"
            "$nodejs"
            "$php"
            "$java"
            "$kotlin"
            "$haskell"
            "$python"
            "$nix_shell"
            "[](fg:green bg:sapphire)"
            "$conda"
            "[](fg:sapphire bg:lavender)"
            "$time"
            "[ ](fg:lavender)"
            "$cmd_duration"
            "$line_break"
            "$character"
          ];

          palette = "catppuccin_mocha";

          os = {
            disabled = false;
            style = "bg:red fg:crust";
          };

          "os.symbols" = {
            Windows = "";
            Ubuntu = "󰕈";
            SUSE = "";
            Raspbian = "󰐿";
            Mint = "󰣭";
            Macos = "󰀵";
            Manjaro = "";
            Linux = "󰌽";
            Gentoo = "󰣨";
            Fedora = "󰣛";
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "󰣇";
            Artix = "󰣇";
            CentOS = "";
            Debian = "󰣚";
            Redhat = "󱄛";
            RedHatEnterprise = "󱄛";
            NixOS = "";
          };

          username = {
            show_always = true;
            style_user = "bg:red fg:crust";
            style_root = "bg:red fg:crust";
            format = "[ $user]($style)";
          };

          directory = {
            style = "bg:peach fg:crust";
            format = "[ $path ]($style)";
            truncation_length = 3;
            truncation_symbol = "…/";
          };

          "directory.substitutions" = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = "󰝚 ";
            Pictures = " ";
            Developer = "󰲋 ";
          };

          git_branch = {
            symbol = "";
            style = "bg:yellow";
            format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";
          };

          git_status = {
            style = "bg:yellow";
            format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)";
          };

          nodejs = {
            symbol = "";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          c = {
            symbol = " ";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          rust = {
            symbol = "";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          golang = {
            symbol = "";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          php = {
            symbol = "";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          java = {
            symbol = " ";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          kotlin = {
            symbol = "";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          haskell = {
            symbol = "";
            style = "bg:green";
            format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
          };

          python = {
            symbol = "";
            style = "bg:green";
            format = "[[ $symbol( $version)(\\($virtualenv\\)) ](fg:crust bg:green)]($style)";
          };

          docker_context = {
            symbol = "";
            style = "bg:sapphire";
            format = "[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)";
          };

          conda = {
            symbol = "  ";
            style = "fg:crust bg:sapphire";
            format = "[$symbol$environment ]($style)";
            ignore_base = false;
          };

          time = {
            disabled = false;
            time_format = "%R";
            style = "bg:lavender";
            format = "[[  $time ](fg:crust bg:lavender)]($style)";
          };

          line_break = {
            disabled = true;
          };

          character = {
            disabled = false;
            success_symbol = "[❯](bold fg:green)";
            error_symbol = "[❯](bold fg:red)";
            vimcmd_symbol = "[❮](bold fg:green)";
            vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
            vimcmd_replace_symbol = "[❮](bold fg:lavender)";
            vimcmd_visual_symbol = "[❮](bold fg:yellow)";
          };

          cmd_duration = {
            show_milliseconds = true;
            format = " in $duration ";
            style = "bg:lavender";
            disabled = false;
            show_notifications = true;
            min_time_to_notify = 45000;
          };

          nix_shell = {
            symbol = " ";
            style = "bg:green";
            format = "[[ $symbol$state( \\($name\\)) ](fg:crust bg:green)]($style)";
          };

          # Catppuccin palettes
          palettes = {
            catppuccin_mocha = {
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
            catppuccin_frappe = {
              rosewater = "#f2d5cf";
              flamingo = "#eebebe";
              pink = "#f4b8e4";
              mauve = "#ca9ee6";
              red = "#e78284";
              maroon = "#ea999c";
              peach = "#ef9f76";
              yellow = "#e5c890";
              green = "#a6d189";
              teal = "#81c8be";
              sky = "#99d1db";
              sapphire = "#85c1dc";
              blue = "#8caaee";
              lavender = "#babbf1";
              text = "#c6d0f5";
              subtext1 = "#b5bfe2";
              subtext0 = "#a5adce";
              overlay2 = "#949cbb";
              overlay1 = "#838ba7";
              overlay0 = "#737994";
              surface2 = "#626880";
              surface1 = "#51576d";
              surface0 = "#414559";
              base = "#303446";
              mantle = "#292c3c";
              crust = "#232634";
            };
            catppuccin_latte = {
              rosewater = "#dc8a78";
              flamingo = "#dd7878";
              pink = "#ea76cb";
              mauve = "#8839ef";
              red = "#d20f39";
              maroon = "#e64553";
              peach = "#fe640b";
              yellow = "#df8e1d";
              green = "#40a02b";
              teal = "#179299";
              sky = "#04a5e5";
              sapphire = "#209fb5";
              blue = "#1e66f5";
              lavender = "#7287fd";
              text = "#4c4f69";
              subtext1 = "#5c5f77";
              subtext0 = "#6c6f85";
              overlay2 = "#7c7f93";
              overlay1 = "#8c8fa1";
              overlay0 = "#9ca0b0";
              surface2 = "#acb0be";
              surface1 = "#bcc0cc";
              surface0 = "#ccd0da";
              base = "#eff1f5";
              mantle = "#e6e9ef";
              crust = "#dce0e8";
            };
            catppuccin_macchiato = {
              rosewater = "#f4dbd6";
              flamingo = "#f0c6c6";
              pink = "#f5bde6";
              mauve = "#c6a0f6";
              red = "#ed8796";
              maroon = "#ee99a0";
              peach = "#f5a97f";
              yellow = "#eed49f";
              green = "#a6da95";
              teal = "#8bd5ca";
              sky = "#91d7e3";
              sapphire = "#7dc4e4";
              blue = "#8aadf4";
              lavender = "#b7bdf8";
              text = "#cad3f5";
              subtext1 = "#b8c0e0";
              subtext0 = "#a5adcb";
              overlay2 = "#939ab7";
              overlay1 = "#8087a2";
              overlay0 = "#6e738d";
              surface2 = "#5b6078";
              surface1 = "#494d64";
              surface0 = "#363a4f";
              base = "#24273a";
              mantle = "#1e2030";
              crust = "#181926";
            };
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
