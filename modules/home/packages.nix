{ pkgs
, osConfig
, lib
, ...
}:
{
  home.packages =
    with pkgs;
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
      nixpkgs-fmt

      stylua
      shfmt
      isort
      black
      taplo
    ]
    # Desktop-only Applications
    # Only install these if the system has a desktop environment enabled.
    ++ lib.optionals osConfig.roles.desktop [
      discord
      onedrive
      youtube-music
      whatsapp-electron
      antigravity-fhs
      brave
      (callPackage ./turtle-wow.nix { })
    ];
}
