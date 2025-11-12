{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    gemini-cli
  ];
}
