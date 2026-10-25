# Platform: dev
# Purpose: Development tools (QA tooling lives in the flake formatter, nix/checks.nix)
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    antigravity-cli
    claude-code
    gh
    neovim
  ];
}
