# Host: grospc
# Purpose: Desktop workstation with gaming optimizations
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "grospc";
  system.stateVersion = "25.11";

  # Kernel: Zen for desktop performance
  boot.kernelPackages = pkgs.linuxPackages_zen;

  bigor = {
    # Platform policies: strategic infrastructure decisions
    platform.policies = {
      dns.mode = "lan-recursive";
      storage.mode = "nfs-client";
    };

    # Capabilities: optional features and services
    capabilities = {
      cpu-power-management.enable = true;
      via.enable = true;

      # Desktop features (expanded from workstation profile)
      audio.enable = true;
      flatpak.enable = true;
      gaming.enable = true;
      desktop.enable = true;
      blocky.enable = true;
    };
  };

  # Bluetooth: Direct configuration (from workstation profile)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Fonts: Direct configuration (from workstation profile)
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      terminus_font
      powerline-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      ipafont
      hanazono
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
        "Noto Color Emoji"
      ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Sans Mono CJK JP"
        "Noto Color Emoji"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  fileSystems."/steamlibrary" = {
    device = "/dev/disk/by-uuid/eca2097b-72d2-46cc-95d3-3b1d546afffc";
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
    ];
  };
}
