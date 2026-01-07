# Home: nixvim-lsp
# Purpose: Language Server Protocol configuration for nixvim
{ inputs, ... }:
let
  flakePath = inputs.self.outPath;
in
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
            # Evaluation base for nixpkgs (uses flake.lock for consistency)
            nixpkgs = {
              expr = ''
                let
                  flake = builtins.getFlake "${flakePath}";
                in
                  import flake.inputs.nixpkgs { system = "x86_64-linux"; }
              '';
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
                    flake = builtins.getFlake "${flakePath}";
                  in
                    lib.mapAttrs (_: cfg: cfg.options) flake.nixosConfigurations
                '';
              };

              # Home Manager options (extracted from NixOS module integration)
              home-manager = {
                expr = ''
                  let
                    flake = builtins.getFlake "${flakePath}";
                    # Get HM options from any host (schema is identical across hosts)
                    hostConfig = builtins.head (builtins.attrValues flake.nixosConfigurations);
                  in
                    hostConfig.options.home-manager.users.type.getSubOptions []
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
