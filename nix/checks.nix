# Module: nix/checks.nix
# Purpose: Flake checks for formatting and linting (flake-parts perSystem)
{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      checks = {
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
      };
    };
}
