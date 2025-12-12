{
  pkgs,
  osConfig,
  lib,
  ...
}: {
  # ============================================================================
  # User Packages
  # ============================================================================
  # Installs user-specific applications via Home Manager.
  # - CLI: Modern tools (eza, ripgrep, lazygit)
  # - GUI: Social, media, and gaming apps (conditioned on desktop role)
  # - Dev: Code quality tools and formatters
  # ============================================================================
  home.packages = with pkgs;
    [
      # Modern CLI replacements
      eza
      fd
      ripgrep
      jq
      lazygit
      gemini-cli

      # Code Quality Tools
      treefmt
      nodePackages.prettier
      alejandra

      stylua
      shfmt
      isort
      black
      taplo
    ]
    # Desktop-only Applications
    # Only install these if the system has a desktop environment enabled.
    ++ lib.optionals osConfig.bigor.roles.desktop [
      discord
      onedrive
      youtube-music
      whatsapp-electron
      antigravity-fhs
      brave
      (callPackage ./turtle-wow.nix {})
    ];
}
