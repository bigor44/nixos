# ============================================================================
# File: /home/bigor/nixos/modules/home/shell/default.nix
# Description: Configures the user's shell environment.
# Author: Bigor
# Date: 2025-12-18
# ============================================================================
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.bigor.home.shell;
in
{
  options.bigor.home.shell = {
    enable = mkEnableOption "Enable user shell configuration";
  };

  config = mkIf cfg.enable {
    # ==========================================================================
    # Programs Configuration
    # ==========================================================================
    programs = {
      # ========================================================================
      # Fish Shell
      # ========================================================================
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

          # System monitoring
          ports = "netstat -tulanp";
          meminfo = "free -h";
          diskinfo = "df -h";
        };
      };

      # ========================================================================
      # Interactive Tools
      # ========================================================================

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

      # Smarter `cd`
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = [ "--cmd cd" ];
      };

      # Better `cat`
      bat = {
        enable = true;
        config = {
          pager = "less -FR";
        };
      };
    };
  };
}
