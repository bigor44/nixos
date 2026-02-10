# Repository Guidelines

## Project Structure & Module Organization

- `flake.nix`: flake entry point (flake-parts) and devshell wiring.
- `hosts/<hostname>/configuration.nix`: host-specific system configs (e.g., `grospc`, `minidesk`, `minipc`).
- `modules/nixos/platform/`: mandatory system infrastructure (always enabled).
- `modules/nixos/features/`: optional features, enabled via `bigor.features.<category>.<name>.enable`.
- `modules/home/`: Home Manager modules and user-level config.
- `nix/`: flake wiring, hooks, devshell utilities.
- `secrets/`: SOPS-encrypted secrets.
- `scripts/`: utility scripts (e.g., `dns-test.sh`, `post_install.sh`).
- `dotfiles/`, `certs/`: user configs and certificates.

## Build, Test, and Development Commands

- `nix develop`: enter the dev shell with required tooling and aliases.
- `nix fmt`: format the repo via `treefmt`.
- `qc`: quick pre-commit checks (formatting/linting on staged files).
- `qf`: full validation (`nix flake check` across hosts).
- `nrs`: `nix flake check && sudo nixos-rebuild switch --flake .`
- `nrb`: `nix flake check && sudo nixos-rebuild boot --flake .`
- `dns-test`: run DNS stack functional checks when DNS changes are made.

## Coding Style & Naming Conventions

- **Nix headers**: every `.nix` file starts with a 2‑line header, e.g.:
  ```nix
  # Feature: audio
  # Purpose: PipeWire audio stack with ALSA and PulseAudio compatibility
  ```
- `default.nix` is reserved for aggregators; `configuration.nix` only for `hosts/*/`.
- Prefer descriptive filenames (`settings.nix`, `manager.nix`, `home.nix`).
- Shell scripts must start with shebang + Script Name + Purpose.
- Formatting is enforced by `treefmt`:
  - `nixfmt` for Nix, `shfmt -i 2 -s -w` for shell,
  - `prettier` for md/json/yaml/html/css,
  - `taplo fmt` for TOML, `stylua` for Lua.

## Testing Guidelines

- **Quick**: `qc` (pre-commit run).
- **Full**: `qf` (`nix flake check`).
- **Targeted**: `dns-test` if DNS settings change.
- No separate unit-test framework; validation is flake checks and linting.

## Commit & Pull Request Guidelines

- Commit history mixes short messages and Conventional Commits (`feat:`, `fix:`, `chore:`). Prefer the Conventional style for new commits.
- Use `gcn -m "feat: ..."` to stage, run checks, and commit safely; use `gps` to run a full flake check before push.
- PRs: ensure `qf` passes, update `README.md` if features change, and include a clear description.

## Security & Configuration Notes

- Never commit plaintext secrets; edit with `sops secrets/secrets.yaml`.
- Open firewall ports inside the feature module that defines the service.
