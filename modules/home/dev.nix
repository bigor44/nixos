# Home: dev
# Purpose: Development tools, Neovim, and AI coding agents (QA tooling lives in the flake formatter, nix/checks.nix)
{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      claude-code
      gcc
      gnumake
      # Plain package: programs.neovim would generate an init.lua clashing with the dotfiles/nvim symlink
      neovim
      python3
      # Global pip installs fail on NixOS; uv manages per-project venvs instead
      uv
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  # OpenCode (Claude Code-like TUI) backed by the local Ollama server
  programs.opencode = {
    enable = true;
    settings = {
      model = "ollama/qwen3.8:latest";
      provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (local)";
        options.baseURL = "http://localhost:11434/v1";
        # Only models pulled with `ollama pull` can be listed here
        models."qwen3.8:latest".name = "Qwen 3.8";
      };
    };
  };
}
