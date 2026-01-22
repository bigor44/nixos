# Feature: nixvim-lsp
# Purpose: LSP configuration for nixvim
{ inputs, ... }:
let
  flakePath = toString inputs.self;
in
{
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      bashls.enable = true;
      marksman.enable = true;

      jsonls = {
        enable = true;
        settings.json = {
          validate.enable = true;
          schemas = [
            {
              fileMatch = [ "package.json" ];
              url = "https://json.schemastore.org/package.json";
            }
          ];
        };
      };

      yamlls = {
        enable = true;
        settings.yaml = {
          keyOrdering = false;
          validate = true;
          schemaStore.enable = true;
        };
      };

      nixd = {
        enable = true;
        settings = {
          nixd = {
            nixpkgs.expr = ''
              let
                flake = builtins.getFlake "${flakePath}";
              in
                import flake.inputs.nixpkgs { system = "x86_64-linux"; }
            '';

            formatting.command = [ "nixfmt" ];

            options = {
              nixos.expr = ''
                let
                  flake = builtins.getFlake "${flakePath}";
                in
                  builtins.mapAttrs (_: cfg: cfg.options) flake.nixosConfigurations
              '';

              home-manager.expr = ''
                let
                  flake = builtins.getFlake "${flakePath}";
                  hostConfig = builtins.head (builtins.attrValues flake.nixosConfigurations);
                in
                  hostConfig.options.home-manager.users.type.getSubOptions []
              '';
            };

            diagnostics = {
              enable = true;
              excluded = [ "unused-binding" ];
            };
          };
        };
      };
    };

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
