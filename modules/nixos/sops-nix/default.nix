# Module: sops-nix
# Purpose: Encrypted secret management with age
{
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";
  };
}
