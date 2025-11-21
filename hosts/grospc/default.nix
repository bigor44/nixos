{
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];
  networking.hostName = "grospc";

  sshd.enable = false;
  desktop.enable = true;
  dashboard.enable = false;

  powerManagement.cpuFreqGovernor = "performance";
  boot.kernelPackages = pkgs.linuxPackages_zen;

  environment.systemPackages = [
    inputs.antigravity-nix.packages.${pkgs.system}.default
  ];

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/84c2f17e-37c6-4ef9-b98c-6862c808990b";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };
}
