{ config, pkgs, lib, desktop, ... }:

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

        # Bash
        mads-hartmann.bash-ide-vscode

        # Python
        ms-python.python
        ms-python.vscode-pylance

        # Markdown
        yzhang.markdown-all-in-one
      ];
      profiles.default.userSettings = {
        "[nix]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
        };
        "python.languageServer" = "Pylance";
        "markdown.preview.breaks" = true;
      };
    };
  };
}
