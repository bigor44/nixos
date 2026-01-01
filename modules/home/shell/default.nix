# Module: shell
# Purpose: Fish shell with Tide prompt, fzf, zoxide, and bat
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
  options.bigor.home.shell.enable = mkEnableOption "Shell configuration";

  config = mkIf cfg.enable {
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

        # Tide prompt configuration (declarative equivalent of `tide configure`)
        interactiveShellInit = ''
          # Tide configuration - Classic style with True color
          set -g tide_character_color brgreen
          set -g tide_character_color_failure brred

          # Prompt style and colors
          set -g tide_prompt_add_newline_before true
          set -g tide_prompt_color_frame_and_connection brblack
          set -g tide_prompt_color_separator_same_color brblack
          set -g tide_prompt_icon_connection ' '
          set -g tide_prompt_min_cols 34
          set -g tide_prompt_pad_items true

          # Left prompt items
          set -g tide_left_prompt_items pwd git
          set -g tide_left_prompt_prefix ""
          set -g tide_left_prompt_separator_diff_color ""
          set -g tide_left_prompt_separator_same_color ""
          set -g tide_left_prompt_suffix ""

          # Right prompt items
          set -g tide_right_prompt_items status cmd_duration context jobs time
          set -g tide_right_prompt_prefix ""
          set -g tide_right_prompt_separator_diff_color ""
          set -g tide_right_prompt_separator_same_color ""
          set -g tide_right_prompt_suffix ""

          # Time format (24-hour)
          set -g tide_time_color brblack
          set -g tide_time_format %H:%M

          # PWD
          set -g tide_pwd_color_anchors brcyan
          set -g tide_pwd_color_dirs cyan
          set -g tide_pwd_color_truncated_dirs magenta
          set -g tide_pwd_icon ""
          set -g tide_pwd_icon_home ""
          set -g tide_pwd_icon_unwritable ""
          set -g tide_pwd_markers .git

          # Git
          set -g tide_git_color_branch brgreen
          set -g tide_git_color_conflicted brred
          set -g tide_git_color_dirty bryellow
          set -g tide_git_color_operation brred
          set -g tide_git_color_staged bryellow
          set -g tide_git_color_stash brgreen
          set -g tide_git_color_untracked brblue
          set -g tide_git_color_upstream brgreen
          set -g tide_git_icon ""
          set -g tide_git_truncation_length 24

          # Status
          set -g tide_status_color brgreen
          set -g tide_status_color_failure brred
          set -g tide_status_icon ✔
          set -g tide_status_icon_failure ✘

          # Command duration
          set -g tide_cmd_duration_color brblack
          set -g tide_cmd_duration_decimals 0
          set -g tide_cmd_duration_threshold 3000

          # Context (user@host)
          set -g tide_context_always_display false
          set -g tide_context_color_default bryellow
          set -g tide_context_color_root brred
          set -g tide_context_color_ssh bryellow

          # Jobs
          set -g tide_jobs_color brgreen
          set -g tide_jobs_icon ""
        '';

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
          nfc = "nix flake check";
          nfu = "nix flake update";
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
        options = [ "--cmd cd" ];
      };

      bat = {
        enable = true;
        config.pager = "less -FR";
      };
    };
  };
}
