# Module: vscode
# Purpose: VSCode configuration with support for Nix, bash, python, lua, markdown, and Claude Code
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bigor.home.vscode;
in
{
  options.bigor.home.vscode = {
    enable = lib.mkEnableOption "VSCode configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;

      # Extensions from nixpkgs
      extensions = with pkgs.vscode-extensions; [
        # Nix language support
        jnoortheen.nix-ide

        # Python support
        ms-python.python
        ms-python.vscode-pylance

        # Bash/Shell support
        mads-hartmann.bash-ide-vscode

        # Markdown support
        yzhang.markdown-all-in-one

        # Git integration
        eamodio.gitlens
        mhutchie.git-graph

        # Code formatting & linting
        esbenp.prettier-vscode
        editorconfig.editorconfig

        # Utilities
        usernamehw.errorlens
        pkief.material-icon-theme
        anthropic.claude-code
      ];

      # VSCode settings
      userSettings = {
        # General editor settings
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
        "editor.fontSize" = 13;
        "editor.fontLigatures" = true;
        "editor.lineNumbers" = "on";
        "editor.rulers" = [
          80
          120
        ];
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        "editor.inlineSuggest.enabled" = true;

        # Files
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Workbench
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.colorTheme" = "Default Dark Modern";
        "workbench.startupEditor" = "none";

        # Terminal
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "terminal.integrated.fontSize" = 13;

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

        # Nix specific settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          nixd = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };

        # Python specific settings
        "python.languageServer" = "Pylance";
        "python.analysis.typeCheckingMode" = "basic";
        "python.formatting.provider" = "black";
        "python.linting.enabled" = true;
        "python.linting.pylintEnabled" = false;
        "python.linting.flake8Enabled" = true;

        # Bash specific settings
        "bashIde.shellcheckPath" = "${pkgs.shellcheck}/bin/shellcheck";

        # Lua specific settings
        "Lua.telemetry.enable" = false;
        "Lua.runtime.version" = "LuaJIT";

        # Markdown specific settings
        "markdown.preview.fontSize" = 14;
        "markdown.extension.toc.levels" = "2..6";

        # Error lens
        "errorLens.enabled" = true;
        "errorLens.fontSize" = "13";

        # Prettier
        "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[yaml]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[markdown]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      };

      # Keybindings
      keybindings = [
        {
          key = "ctrl+shift+f";
          command = "workbench.action.findInFiles";
        }
        {
          key = "ctrl+p";
          command = "workbench.action.quickOpen";
        }
      ];
    };

    # Install additional tools needed by VSCode extensions
    home.packages = with pkgs; [
      # Nix tools
      nixd
      nixfmt-rfc-style
      statix
      deadnix

      # Python tools
      python3
      python3Packages.black
      python3Packages.flake8
      python3Packages.pylint

      # Bash tools
      shellcheck
      shfmt

      # Lua tools
      lua-language-server

      # Markdown tools
      marksman

      # General tools
      nodePackages.prettier
    ];
  };
}
