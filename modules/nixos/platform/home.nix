# Platform: home
# Purpose: Home Manager integration
{ inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.bigor = import ../../home/home.nix;
  };
}
