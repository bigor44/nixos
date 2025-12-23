# Home: nixvim-lsp
# Purpose: Language Server Protocol configuration for nixvim
{
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      # ==========================================================================
      # Bash
      # ==========================================================================
      bashls.enable = true;

      # ==========================================================================
      # Markdown
      # ==========================================================================
      marksman.enable = true;

      # ==========================================================================
      # JSON / Web
      # ==========================================================================
      jsonls = {
        enable = true;
        settings.json = {
          validate.enable = true;
          schemas = [
            {
              fileMatch = [ "*.json" ];
              url = "https://json.schemastore.org/package.json";
            }
          ];
        };
      };

      # ==========================================================================
      # YAML
      # ==========================================================================
      yamlls = {
        enable = true;
        settings.yaml = {
          keyOrdering = false;
          validate = true;
          schemaStore.enable = true;
        };
      };

      # ==========================================================================
      # Nix (nixd)
      # ==========================================================================
      nixd = {
        enable = true;

        settings = {
          nixd = {
            # Evaluation base for nixpkgs
            nixpkgs = {
              expr = "import <nixpkgs> {}";
            };

            # Formatter (must match Conform / treefmt)
            formatting = {
              command = [ "nixfmt" ];
            };

            # Options: Core of autocompletion
            options = {
              # All NixOS options from ALL hosts
              nixos = {
                expr = ''
                  let
                    flake = builtins.getFlake (toString ./../../../../..);
                  in
                    lib.mapAttrs (_: cfg: cfg.options) flake.nixosConfigurations
                '';
              };

              # All Home Manager options
              home-manager = {
                expr = ''
                  let
                    flake = builtins.getFlake (toString ./../../../../..);
                  in
                    lib.mapAttrs (_: cfg: cfg.options) flake.homeConfigurations
                '';
              };
            };

            # Diagnostics
            diagnostics = {
              enable = true;
              excluded = [
                "unused-binding"
              ];
            };
          };
        };
      };
    };

    # ============================================================================
    # Keymaps
    # ============================================================================
    keymaps = {
      lspBuf = {
        gd = "definition";
        gD = "declaration";
        gr = "references";
        gi = "implementation";
        K = "hover";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
        "<leader>f" = "format";
      };
    };
  };
}
