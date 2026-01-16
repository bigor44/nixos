# Platform: nix-core
# Purpose: Core Nix configuration (caches, flakes, internal CA trust)
{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Trust internal CA for local services (HTTPS via Caddy)
  security.pki.certificateFiles = [ "${inputs.self}/certs/minipc-ca.pem" ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "bigor"
      ];
      max-jobs = "auto";

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      ];
    };

    optimise.automatic = true;
  };
}
