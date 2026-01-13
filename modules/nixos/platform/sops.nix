# Feature: sops
# Purpose: Secrets management with sops-nix
{ inputs, ... }:
{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
