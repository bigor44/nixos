# Module: nix/checks.nix
# Purpose: Flake checks for formatting and linting (flake-parts perSystem)
{ self, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      checks =
        let
          # Generate assertion checks for all NixOS configurations
          # This ensures policy assertions are validated during `nix flake check`
          # Strategy: Force evaluation of system.build.toplevel metadata which includes assertions
          assertionChecks = lib.mapAttrs' (
            hostName: config:
            let
              # Access the system config
              cfg = config.config;
              # Safe assertion access with fallback to empty list
              # Protects against modules that don't define assertions or overrides
              assertions = cfg.assertions or [ ];
              # Force evaluation of all assertions by accessing system.checks
              # This will fail at eval-time if any assertion is false
              failedAssertions = lib.filter (x: !x.assertion) assertions;
            in
            lib.nameValuePair "${hostName}-assertions" (
              if failedAssertions != [ ] then
                throw ''
                  Failed assertions for ${hostName}:
                  ${lib.concatMapStringsSep "\n" (x: "- ${x.message}") failedAssertions}
                ''
              else
                pkgs.writeTextFile {
                  name = "${hostName}-assertions";
                  text = ''
                    All assertions passed for ${hostName}
                    Total assertions checked: ${toString (lib.length assertions)}
                  '';
                }
            )
          ) self.nixosConfigurations;
        in
        {
          # Formatting check with treefmt
          nix-fmt =
            pkgs.runCommand "nix-fmt"
              {
                nativeBuildInputs = with pkgs; [
                  treefmt
                  nixfmt
                  shfmt
                  nodePackages.prettier
                  taplo
                ];
              }
              ''
                src="${self}"

                # Copy source to a writable location
                cp -r "$src" ./source
                chmod -R u+w ./source

                echo "Checking formatting with treefmt..."
                treefmt --no-cache --fail-on-change -C ./source

                touch $out
              '';

          # Linting check with statix and deadnix
          nix-lint =
            pkgs.runCommand "nix-lint"
              {
                nativeBuildInputs = with pkgs; [
                  statix
                  deadnix
                ];
              }
              ''
                src="${self}"

                echo "Running statix on $src..."
                statix_output=$(statix check --ignore .* "$src" 2>&1) || true
                echo "$statix_output"
                if echo "$statix_output" | grep -qE "Warning:|Error:"; then
                  echo "statix found issues"
                  exit 1
                fi

                echo "Running deadnix on $src..."
                deadnix --fail "$src"

                touch $out
              '';
        }
        // assertionChecks; # Merge assertion checks for all hosts
    };
}
