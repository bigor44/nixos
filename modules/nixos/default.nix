{ ... }:
{
  imports = [
    ./core
    ./roles
    ./desktop
    ./services
    ./nixvim
  ];
  system.stateVersion = "25.05";
}
