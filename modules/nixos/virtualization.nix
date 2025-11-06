/*
Title: Virtualization Configuration
Description: Configures libvirtd for running virtual machines with KVM/QEMU.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.virtualization.enable {
  # Enable libvirtd for virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # Enable KVM nested virtualization
  boot.extraModprobeConfig = "options kvm_amd nested=1";

  # Add necessary packages for VM management
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    looking-glass-client
  ];

  # Add user to libvirtd group
  users.users.bigor.extraGroups = ["libvirtd"];

  # Configure default network
  virtualisation.libvirtd.extraConfig = ''
    unix_sock_group = "libvirtd"
    unix_sock_rw_perms = "0770"
  '';

  # Enable necessary services
  programs.dconf.enable = true;

  # Open firewall for VNC if needed
  networking.firewall.allowedTCPPorts = [5900];
}
