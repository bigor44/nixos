---
name: new-feature
description: Scaffold a new optional NixOS feature module under modules/nixos/features/<category>/<name>.nix, register it in nix/modules.nix, and optionally enable it on a host. Use when adding a new service, app set, or hardware feature.
---

Arguments: `$ARGUMENTS` (e.g. `services/jellyfin` or a description). Ask for category, name, purpose, and target host(s) if not clear.

1. Look at an existing sibling module in the same category and mirror its style.
2. Create `modules/nixos/features/<category>/<name>.nix`:

   ```nix
   # Feature: <category>-<name>
   # Purpose: <one line>
   { lib, config, ... }:
   let
     cfg = config.bigor.features.<category>.<name>;
   in
   {
     options.bigor.features.<category>.<name>.enable = lib.mkEnableOption "<description>";

     config = lib.mkIf cfg.enable {
       # ...
     };
   }
   ```

   - Open firewall ports in this module, not elsewhere.

3. Add the path to the matching section of `nix/modules.nix` (otherwise it's silently ignored).
4. If requested, enable it in `hosts/<host>/configuration.nix` under the existing nested `bigor.features.<category>` attrset.
5. `git add -N` the new file, then run the `/verify` skill (fmt, pre-commit, flake check). If features changed, update README.md.
