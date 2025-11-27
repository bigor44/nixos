{...}: {
  imports = [
    ./core
    ./roles
    ./desktop
    ./services
  ];
  system.stateVersion = "25.05";
}
