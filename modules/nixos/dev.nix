# Platform: dev
# Purpose: Development tools (QA tooling lives in the flake devshell)
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    antigravity-cli
    claude-code
    gh
    neovim
  ];
}
