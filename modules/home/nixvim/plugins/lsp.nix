# ============================================================================
# File: lsp.nix
# Description: NixVim LSP configuration.
# Author: Bigor
# Date: 2025-12-18
# Purpose: Configures Language Server Protocol (LSP) for various languages in NixVim.
# ============================================================================

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
            # ----------------------------------------------------------------------
            # nixpkgs : base d’évaluation
            # ----------------------------------------------------------------------
            nixpkgs = {
              expr = "import <nixpkgs> {}";
            };

            # ----------------------------------------------------------------------
            # Formatter (doit matcher Conform / treefmt)
            # ----------------------------------------------------------------------
            formatting = {
              command = [ "nixfmt" ];
            };

            # ----------------------------------------------------------------------
            # Options : cœur de l’auto-complétion
            # ----------------------------------------------------------------------
            options = {
              # Toutes les options NixOS de TOUS les hosts
              nixos = {
                expr = ''
                  let
                    flake = builtins.getFlake (toString ./../../../../..);
                  in
                    lib.mapAttrs (_: cfg: cfg.options) flake.nixosConfigurations
                '';
              };

              # Toutes les options Home Manager
              home-manager = {
                expr = ''
                  let
                    flake = builtins.getFlake (toString ./../../../../..);
                  in
                    lib.mapAttrs (_: cfg: cfg.options) flake.homeConfigurations
                '';
              };
            };

            # ----------------------------------------------------------------------
            # Diagnostics
            # ----------------------------------------------------------------------
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
