# Module: dns-stack-validator
# Purpose: Lightweight DNS stack validation script
{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "dns-stack-validator";

  runtimeInputs = with pkgs; [
    ldns # drill command
    bind # host/dig commands
    netcat # nc command
    curl
    systemd # systemctl/journalctl
  ];

  text = ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Colors for output
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color

    # Counters
    PASSED=0
    FAILED=0
    WARNINGS=0

    print_header() {
      echo -e "''${BLUE}==================================================''${NC}"
      echo -e "''${BLUE}  DNS Stack Validator (Blocky + Unbound)''${NC}"
      echo -e "''${BLUE}==================================================''${NC}"
      echo ""
    }

    print_test() {
      echo -e "''${YELLOW}>>''${NC} $1"
    }

    print_success() {
      echo -e "  ''${GREEN}[OK]''${NC} $1"
      ((PASSED++))
    }

    print_error() {
      echo -e "  ''${RED}[FAIL]''${NC} $1"
      ((FAILED++))
    }

    print_warning() {
      echo -e "  ''${YELLOW}[WARN]''${NC} $1"
      ((WARNINGS++))
    }

    print_summary() {
      echo ""
      echo -e "''${BLUE}==================================================''${NC}"
      echo -e "''${BLUE}  Summary''${NC}"
      echo -e "''${BLUE}==================================================''${NC}"
      echo -e "  ''${GREEN}Passed:''${NC}   $PASSED"
      echo -e "  ''${RED}Failed:''${NC}   $FAILED"
      echo -e "  ''${YELLOW}Warnings:''${NC} $WARNINGS"

      if [ $FAILED -eq 0 ]; then
        echo -e "\n''${GREEN}[OK] All tests passed!''${NC}"
        exit 0
      else
        echo -e "\n''${RED}[FAIL] Some tests failed!''${NC}"
        exit 1
      fi
    }

    # ============================================
    # Main Script
    # ============================================
    print_header

    # ============================================
    # Test 1: Service Status
    # ============================================
    print_test "Checking service status..."

    if systemctl is-active --quiet unbound.service; then
      print_success "Unbound service is running"
    else
      print_error "Unbound service is not running"
    fi

    if systemctl is-active --quiet blocky.service; then
      print_success "Blocky service is running"
    else
      print_error "Blocky service is not running"
    fi

    # ============================================
    # Test 2: Port Availability
    # ============================================
    print_test "Checking port availability..."

    if nc -z -w 1 127.0.0.1 5335 2>/dev/null; then
      print_success "Unbound listening on port 5335"
    else
      print_error "Unbound not listening on port 5335"
    fi

    if nc -z -w 1 127.0.0.1 53 2>/dev/null; then
      print_success "Blocky listening on port 53"
    else
      print_error "Blocky not listening on port 53"
    fi

    # ============================================
    # Test 3: Startup Dependencies
    # ============================================
    print_test "Checking startup logs..."

    if journalctl -u blocky.service --since "5 minutes ago" | grep -q "Unbound is ready after"; then
      print_success "Blocky waited for Unbound (dependency check passed)"
    elif journalctl -u blocky.service --since "5 minutes ago" | grep -q "Unbound health check passed"; then
      print_success "Blocky health check passed (dependency check passed)"
    else
      print_warning "Could not verify Unbound dependency check in recent logs"
    fi

    # ============================================
    # Test 4: Unbound Resolution
    # ============================================
    print_test "Testing Unbound direct queries..."

    if drill @127.0.0.1 -p 5335 example.com A | grep -q "ANSWER SECTION"; then
      print_success "Unbound resolves external domains"
    else
      print_error "Unbound failed to resolve example.com"
    fi

    # Test DNSSEC with a known valid domain
    if drill @127.0.0.1 -p 5335 -D sigok.verteiltesysteme.net A 2>&1 | grep -q "SECURE"; then
      print_success "Unbound DNSSEC validates secure domains"
    else
      print_error "Unbound DNSSEC validation not working (sigok.verteiltesysteme.net should be SECURE)"
    fi

    # Test that DNSSEC rejects invalid signatures
    if ! drill @127.0.0.1 -p 5335 sigfail.verteiltesysteme.net A 2>&1 | grep -q "ANSWER"; then
      print_success "Unbound DNSSEC rejects invalid signatures"
    else
      print_error "Unbound DNSSEC should reject sigfail.verteiltesysteme.net"
    fi

    # ============================================
    # Test 5: Blocky Local DNS
    # ============================================
    print_test "Testing Blocky local DNS rewrites..."

    # Test a known local domain (adjust based on your config)
    if drill @127.0.0.1 minipc.bigor.lan A 2>&1 | grep -q "ANSWER SECTION"; then
      print_success "Blocky resolves local .bigor.lan domains"
    else
      print_warning "Could not verify local DNS rewrites (minipc.bigor.lan)"
    fi

    # ============================================
    # Test 6: Blocky External Resolution
    # ============================================
    print_test "Testing Blocky external resolution..."

    if drill @127.0.0.1 cloudflare.com A | grep -q "ANSWER SECTION"; then
      print_success "Blocky forwards external queries to Unbound"
    else
      print_error "Blocky failed to resolve cloudflare.com"
    fi

    # ============================================
    # Test 7: Ad Blocking
    # ============================================
    print_test "Testing ad blocking..."

    # Test known ad domain
    if drill @127.0.0.1 doubleclick.net A 2>&1 | grep -q "0.0.0.0"; then
      print_success "Blocky blocks ad domains (doubleclick.net → 0.0.0.0)"
    elif drill @127.0.0.1 doubleclick.net A 2>&1 | grep -q "NXDOMAIN"; then
      print_success "Blocky blocks ad domains (doubleclick.net → NXDOMAIN)"
    else
      print_warning "Could not verify ad blocking (blocklists may not be loaded yet)"
    fi

    # ============================================
    # Test 8: Prometheus Metrics
    # ============================================
    print_test "Testing Prometheus metrics..."

    if curl -s http://127.0.0.1:4000/metrics | grep -q "blocky_"; then
      print_success "Blocky metrics endpoint responding"
    else
      print_error "Blocky metrics endpoint not responding"
    fi

    # ============================================
    # Test 9: System DNS Configuration
    # ============================================
    print_test "Checking system DNS configuration..."

    if grep -q "127.0.0.1" /etc/resolv.conf 2>/dev/null; then
      print_success "System configured to use Blocky (127.0.0.1)"
    else
      print_warning "System may not be using Blocky as primary DNS"
    fi

    # System-level resolution test
    if host example.com >/dev/null 2>&1; then
      print_success "System DNS resolution working"
    else
      print_error "System DNS resolution failed"
    fi

    # ============================================
    # Summary
    # ============================================
    print_summary
  '';
}
