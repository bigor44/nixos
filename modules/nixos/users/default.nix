{pkgs, ...}: {
  # ============================================================================
  # User Management
  # ============================================================================
  # Defines the primary user 'bigor' and system-wide authentication settings.
  # - Adds user to 'wheel' for sudo access (passwordless).
  # - Sets Fish as the default shell.
  # - Configures SSH authorized keys.
  # ============================================================================
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlRJ6EUpCIAj+SxgOIlEIdDuBugF7BcbV0MkqmK+jfI bigor44@gmail.com"
    ];
  };

  # Passwordless sudo for the 'wheel' group for convenience
  security.sudo.wheelNeedsPassword = false;

  # Ensure Fish is listed in /etc/shells.
  # This is required for it to be a valid login shell for users (e.g. for SSH or display managers).
  environment.shells = with pkgs; [fish];
}
