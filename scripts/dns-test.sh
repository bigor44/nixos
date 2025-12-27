#!/usr/bin/env bash
set -euo pipefail

DNS_SERVER="127.0.0.1"
TIMEOUT=2

fail() {
  echo "❌ $1"
  exit 1
}

ok() {
  echo "✅ $1"
}

dig_test() {
  dig @"$DNS_SERVER" "$1" +time="$TIMEOUT" +tries=1 +short
}

echo "== DNS Stack Functional Test =="

# 1. DNS reachable
dig_test google.com >/dev/null || fail "DNS server not reachable"
ok "DNS server reachable"

# 2. Local rewrites
EXPECTED_MINIPC="$(dig_test minipc.bigor.lan)"
[ -n "$EXPECTED_MINIPC" ] || fail "Local rewrite minipc.bigor.lan failed"
ok "Local rewrite minipc.bigor.lan → $EXPECTED_MINIPC"

# 3. External resolution
dig_test google.com | grep -E '^[0-9.]+' >/dev/null \
  || fail "External resolution failed"
ok "External resolution works"

# 4. Ad blocking
BLOCKED="$(dig_test ads.youtube.com || true)"
[ "$BLOCKED" = "0.0.0.0" ] || fail "Ad blocking not effective"
ok "Ad blocking works"

# 5. DNSSEC validation
dig @"$DNS_SERVER" sigok.verteiltesysteme.net +dnssec +short >/dev/null \
  || fail "DNSSEC validation failed"
ok "DNSSEC validation works"

echo "🎉 DNS stack OK"

