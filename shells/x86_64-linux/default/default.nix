{
  pkgs,
  inputs,
  system,
  ...
}: let
  hooks = inputs.git-hooks.lib.${system}.run {
    src = inputs.self;

    # CORRECTION : On utilise 'tools' pour passer nos paquets.
    # Cela évite que git-hooks n'importe sa propre version de nixpkgs (ce qui causait l'avertissement).
    tools = pkgs;

    hooks = {
      # Formattage (utilise votre treefmt.toml)
      treefmt.enable = true;

      # Linters Nix
      statix.enable = true;
      deadnix.enable = true;
      # Linter pour les scripts Shell
      shellcheck.enable = true;
    };
  };
in
  pkgs.mkShell {
    inherit (hooks) shellHook;

    packages = with pkgs;
      [
        # Outils liés aux hooks
        treefmt
        statix
        deadnix
        shellcheck

        # Vos outils de dev
        nh
        git
        just
      ]
      ++ hooks.enabledPackages;
  }
