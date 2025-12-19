# ============================================================================
# File: modules/home/sops/default.nix
# Description: Configures sops-nix for home-manager secrets.
# Author: Bigor
# Date: 2025-12-19
# ============================================================================
{
  config,
  lib,
  ...
}:
let
  cfg = config.bigor.home.sops;
in
{
  options.bigor.home.sops = {
    enable = lib.mkEnableOption "Enable sops-nix for home-manager";
  };

  config = lib.mkIf cfg.enable {
    sops = {
      # Use the user's age key for decryption
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      # Default secrets file
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      secrets = {
        anthropic_api_key = { };
      };
    };
  };
}
