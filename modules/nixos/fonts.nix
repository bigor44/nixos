/*
  Title: Font Configuration
  Description: Configures system-wide fonts, including console fonts and various Nerd Fonts.
*/
{ pkgs, ... }:
{
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    terminus_font
    powerline-fonts
  ];
}
