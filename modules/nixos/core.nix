# Platform: core
# Purpose: Base system: bootloader, firmware, Nix and nh, the bigor user, French locale and fonts
{ pkgs, ... }:
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Caps the boot menu entries and the kernels/initrds stored on the ESP
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };
  # LVFS firmware updates, applied manually with fwupdmgr
  services.fwupd.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Dedupe the store by hardlinking; garbage collection is left to nh clean below
      auto-optimise-store = true;
    };
  };
  programs = {
    nh = {
      enable = true;
      # Lets `nh os switch|boot` run without a flake argument
      flake = "/home/bigor/nixos";
      clean = {
        enable = true;
        dates = "weekly";
        # Keeps rollback targets even after a long time without rebuilding
        extraArgs = "--keep-since 7d --keep 5";
      };
    };
    fish.shellAbbrs = {
      nfu = "nix flake update";
      nclean = "nh clean all";
      qf = "nix flake check";
      # Checks (format + lint + eval) gate every push and switch
      gps = "nix flake check && git push";
      nrs = "nix flake check ~/nixos && nh os switch";
      nrb = "nix flake check ~/nixos && nh os boot";
    };
  };
  users.users.bigor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "Europe/Paris";
  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    # en_US kept for tools that only ship English or expect it
    supportedLocales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };
  services.xserver.xkb.layout = "fr";
  console = {
    keyMap = "fr";
    # 32 px bitmap font; the default console font is unreadably small at high resolutions
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132b.psf.gz";
  };
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      terminus_font
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
    # Ordered fallback chains: Latin first, then CJK glyphs, then emoji
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
}
