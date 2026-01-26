# Flake: home-manager
# Purpose: Home Manager integration bridge
{ inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.bigor = import ../modules/home;
  };
}
