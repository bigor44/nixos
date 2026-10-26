---
name: verify
description: Validate changes to this NixOS flake without touching the running system — format, lint (pre-commit), nix flake check, and optionally build a host closure. Use after editing any .nix or shell file and before committing.
---

Arguments: `$ARGUMENTS` — optional host name(s) to build (`grospc` or `all`).

1. Make new files visible to the flake: `git status --porcelain` and `git add -N <file>` for each untracked file that belongs in the repo.
2. `nix fmt` — runs every pre-commit hook (formatters, statix, deadnix, shellcheck, ...) on all files and applies fixes.
3. `nix flake check`
4. If hosts were given (or a host's config/hardware was edited), build without switching:
   `nix build --no-link .#nixosConfigurations.<host>.config.system.build.toplevel`
5. Report pass/fail per step with the relevant error output. Never run `nixos-rebuild`, `nrs`, or `nrb` here — offer it and wait for explicit approval.
