{pkgs, ...}: {
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRJ6EUpCIAj+SxgOIlEIdDuBugF7BcbV0MkqmK+jfI bigor44@gmail.com"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  environment.shells = with pkgs; [zsh];
}
