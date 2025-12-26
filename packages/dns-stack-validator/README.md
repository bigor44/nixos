# DNS Stack Validator

Comprehensive validation tool for the Blocky + Unbound DNS stack.

## Usage

Run on any system with Blocky and/or Unbound enabled:

```bash
nix run .#dns-stack-validator
```

Or from outside the flake:

```bash
nix run github:bigor44/nixos#dns-stack-validator
```

## Tests Performed

### Service Health

- ✅ Unbound service status (systemd)
- ✅ Blocky service status (systemd)
- ✅ Port availability (5335 for Unbound, 53 for Blocky)

### Startup Dependencies

- ✅ Verifies Blocky waited for Unbound (checks journalctl logs)
- ✅ Confirms health check script executed successfully

### Unbound DNS Resolution

- ✅ External domain resolution (`example.com`)
- ✅ DNSSEC validation with positive test (`sigok.verteiltesysteme.net` → SECURE)
- ✅ DNSSEC validation with negative test (`sigfail.verteiltesysteme.net` → rejected)

### Blocky DNS Features

- ✅ Local DNS rewrites (`.bigor.lan` domains)
- ✅ External DNS forwarding to Unbound
- ✅ Ad blocking (`doubleclick.net` → 0.0.0.0)

### Monitoring & Configuration

- ✅ Prometheus metrics endpoint (`http://127.0.0.1:4000/metrics`)
- ✅ System DNS configuration (`/etc/resolv.conf`)
- ✅ System-level DNS resolution

## Output Format

The validator uses ASCII-only output for maximum compatibility:

```
==================================================
  DNS Stack Validator (Blocky + Unbound)
==================================================

>> Checking service status...
  [OK] Unbound service is running
  [OK] Blocky service is running

>> Testing Unbound direct queries...
  [OK] Unbound resolves external domains
  [OK] Unbound DNSSEC validates secure domains
  [OK] Unbound DNSSEC rejects invalid signatures

...

==================================================
  Summary
==================================================
  Passed:   15
  Failed:   0
  Warnings: 1

[OK] All tests passed!
```

## Exit Codes

- **0**: All tests passed
- **1**: One or more tests failed

## Requirements

The validator expects:

- Either Unbound, Blocky, or both services to be enabled
- Standard ports: 5335 (Unbound), 53 (Blocky)
- Standard metrics port: 4000 (Blocky)

Tests will show warnings if services are not running, but won't fail unless critical functionality is broken.

## Implementation

This is a `writeShellApplication` package with built-in ShellCheck validation. It uses:

- `ldns` (drill) for DNS queries
- `bind` (host/dig) for system DNS testing
- `netcat` for port availability checks
- `curl` for metrics endpoint testing
- `systemd` for service status and logs

All dependencies are automatically included in the runtime environment.
