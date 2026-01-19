# Platform: system.users
# Purpose: Primary user configuration with Zsh shell and passwordless sudo
{ pkgs, ... }:
{
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRJ6EUpCIAj+SxgOIlEIdDuBugF7BcbV0MkqmK+jfI bigor44@gmail.com"
    ];
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  security.sudo.wheelNeedsPassword = false;
  environment.shells = with pkgs; [ zsh ];
}
