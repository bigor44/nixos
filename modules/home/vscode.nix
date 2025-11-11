/*
  Title: VSCode Configuration
  Description: Configures VSCode with extensions and settings for various languages.
*/
{
  config,
  pkgs,
  lib,
  desktop,
  ...
}:

with lib;

let
  cfg = desktop;
in
{
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;

      profiles.default.extensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide

        # Bash/Shell
        mads-hartmann.bash-ide-vscode
        timonwong.shellcheck

        # Python
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy

        # Markdown
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint

        # Git
        eamodio.gitlens
        mhutchie.git-graph

        # General productivity
        vscodevim.vim
        usernamehw.errorlens
        pkief.material-icon-theme
        github.copilot
        github.copilot-chat

        # Formatter
        esbenp.prettier-vscode

        # Docker (if you use containers)
        ms-azuretools.vscode-docker

        # YAML/JSON
        redhat.vscode-yaml

        # Remote development
        ms-vscode-remote.remote-ssh
      ];

      profiles.default.userSettings = {
        # Editor settings
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "editor.lineNumbers" = "relative";
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "editor.minimap.enabled" = false;
        "editor.rulers" = [
          80
          120
        ];
        "editor.renderWhitespace" = "selection";
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "explicit";
        };

        # Files
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Workbench
        "workbench.colorTheme" = "Default Dark Modern";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
        "workbench.tree.indent" = 20;

        # Terminal
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.defaultProfile.linux" = "fish";

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "gitlens.hovers.currentLine.over" = "line";

        # Language-specific settings
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
        };

        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.formatOnSave" = true;
          "editor.codeActionsOnSave" = {
            "source.organizeImports" = "explicit";
          };
          "editor.tabSize" = 4;
        };

        "[markdown]" = {
          "editor.wordWrap" = "on";
          "editor.quickSuggestions" = {
            "comments" = "off";
            "strings" = "off";
            "other" = "off";
          };
        };

        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.tabSize" = 2;
        };

        "[yaml]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.tabSize" = 2;
        };

        # Python
        "python.languageServer" = "Pylance";
        "python.analysis.typeCheckingMode" = "basic";
        "python.analysis.autoImportCompletions" = true;

        # Markdown
        "markdown.preview.breaks" = true;
        "markdown.preview.fontSize" = 14;

        # Vim (if using vscodevim)
        "vim.useSystemClipboard" = true;
        "vim.hlsearch" = true;
        "vim.leader" = "<space>";

        # Error Lens
        "errorLens.enabledDiagnosticLevels" = [
          "error"
          "warning"
        ];
        "errorLens.fontSize" = "12";

        # Nix IDE specific
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };
      };

      # Keybindings
      profiles.default.keybindings = [
        {
          key = "ctrl+h";
          command = "workbench.action.navigateLeft";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.navigateRight";
        }
        {
          key = "ctrl+k";
          command = "workbench.action.navigateUp";
        }
        {
          key = "ctrl+j";
          command = "workbench.action.navigateDown";
        }
      ];
    };
  };
}
