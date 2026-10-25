# Platform: system.users
# Purpose: Primary user configuration with Zsh shell and passwordless sudo
{ pkgs, ... }:
{
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
  environment.shells = with pkgs; [ zsh ];
}
