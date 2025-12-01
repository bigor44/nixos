{ pkgs, ... }:
{
  # Define the primary user account
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable sudo privileges
    shell = pkgs.fish; # Set default shell to Fish
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRJ6EUpCIAj+SxgOIlEIdDuBugF7BcbV0MkqmK+jfI bigor44@gmail.com"
    ];
  };

  # Passwordless sudo for the 'wheel' group for convenience
  security.sudo.wheelNeedsPassword = false;

  # Ensure Fish is listed as a valid login shell
  environment.shells = with pkgs; [ fish ];
}
