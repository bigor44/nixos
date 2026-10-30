# Host: grospc
# Purpose: Hardware scan output from nixos-generate-config (disks, initrd modules); regenerate rather than hand-edit
{
  config,
  lib,
  # Path to nixpkgs' nixos/modules, used to pull in the installer's hardware profile
  modulesPath,
  ...
}:
{
  imports = [
    # Enables redistributable firmware for devices the scanner could not identify
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    # Drivers the initrd needs to reach the NVMe root and USB keyboards before / is mounted
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };
  # By UUID so the mounts survive device renumbering
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5d1dace7-ba6a-4122-9ceb-664d17e7ab39";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C3E1-6EC5";
    fsType = "vfat";
    # ESP readable by root only: systemd-boot warns about a world-readable random seed
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  swapDevices = [ ];
  # mkDefault: low priority, so any other module can still override these
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
