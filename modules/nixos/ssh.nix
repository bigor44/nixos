/*
Title: SSH Server Configuration
Description: Configures the OpenSSH server with secure settings.
*/
{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
