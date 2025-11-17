#!/usr/bin/env bash
# refactor-to-role.sh
# Convert boolean flags (desktop.enable, server.enable, …) to a single `role` variable.

set -euo pipefail

# 1. Map old flag → role
declare -A MAP=(
  [desktop]="desktop"
  [server]="server"
)

# 2. Files that may contain references (space separated)
MODULES=$(find modules -type f -name '*.nix')

# 3. Replace every  config.<flag>.enable  →  config.role == "<role>"
for flag in "${!MAP[@]}"; do
  role=${MAP[$flag]}
  sed -i -E "s/\bconfig\.${flag}\.enable\b/config.role == \"${role}\"/g" $MODULES
done

# 4. Replace mkIf conditionals that used the flag directly
for flag in "${!MAP[@]}"; do
  role=${MAP[$flag]}
  sed -i -E "s/lib\.mkIf\s+\(\s*config\.${flag}\.enable\s*\)/lib.mkIf (config.role == \"${role}\")/g" $MODULES
done

# 5. Remove old option definitions from options.nix
cat >modules/nixos/options.nix <<'EOF'
{ lib, ... }:
{
  options = {
    role = lib.mkOption {
      type = lib.types.enum [ "desktop" "server" "minimal" ];
      default = "minimal";
      description = "System role: desktop, server, or minimal";
    };
  };
}
EOF

# 6. Update host files to use `role` instead of flags
sed -i -E '/desktop\.enable\s*=/d; /server\.enable\s*=/d' hosts/*/default.nix
# grospc is desktop
sed -i '/^  imports = \[/a\  role = "desktop";' hosts/grospc/default.nix
# minipc is server
sed -i '/^  imports = \[/a\  role = "server";' hosts/minipc/default.nix

echo "Done. Review the changes with:"
echo "  git diff"
