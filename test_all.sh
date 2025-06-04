#!/bin/bash
#
# Comprehensive test script for the dotfiles-playbook
# This script runs tests for all roles and verifies idempotence

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to print messages
print_message() {
  echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}WARNING:${NC} $1"
}

print_error() {
  echo -e "${RED}ERROR:${NC} $1"
}

print_section() {
  echo
  echo -e "${BOLD}${BLUE}$1${NC}"
  echo -e "${BLUE}$(printf '=%.0s' {1..50})${NC}"
}

# Create test results directory
RESULTS_DIR="$HOME/dotfiles-test-results"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
TEST_DIR="$RESULTS_DIR/$TIMESTAMP"
mkdir -p "$TEST_DIR"

# Log file setup
LOG_FILE="$TEST_DIR/test_summary.log"
touch "$LOG_FILE"

log_result() {
  echo "$1" | tee -a "$LOG_FILE"
}

# Print start header
print_section "DOTFILES PLAYBOOK COMPREHENSIVE TESTING"
log_result "Test run started at: $(date)"
log_result "macOS Version: $(sw_vers -productVersion)"
log_result "Architecture: $(uname -m)"
log_result "Results saved to: $TEST_DIR"
echo

# Get all roles
cd "$(dirname "$0")"
ROLES=$(find ./roles -maxdepth 1 -name 'adambware.*' -type d | sed 's|./roles/||')

# 1. Individual role tests
print_section "TESTING INDIVIDUAL ROLES"

FAILED_ROLES=""
PASSED_ROLES=""

for role in $ROLES; do
  role_name=${role#adambware.}
  
  print_message "Testing role: $role"
  
  # Skip test role if it exists
  if [ "$role" == "adambware.test" ]; then
    print_warning "Skipping test role"
    continue
  fi
  
  # Check if role has test file
  if [ ! -f "./roles/$role/tests/test_${role_name}.yml" ]; then
    print_warning "No test file found for $role, skipping"
    continue
  fi
  
  # Run test for role
  if ./setup.sh --test --role=$role -v --output="$TEST_DIR/${role_name}_test.log"; then
    print_message "Role $role passed tests ✅"
    PASSED_ROLES="$PASSED_ROLES $role"
    log_result "✅ $role: PASSED"
  else
    print_error "Role $role failed tests ❌"
    FAILED_ROLES="$FAILED_ROLES $role"
    log_result "❌ $role: FAILED"
  fi
  
  # Test idempotence for role
  print_message "Testing idempotence for $role"
  if ./setup.sh --idempotence --role=$role --output="$TEST_DIR/${role_name}_idempotence.log"; then
    print_message "Role $role is idempotent ✅"
    log_result "✅ $role: IDEMPOTENT"
  else
    print_warning "Role $role is not fully idempotent ⚠️"
    log_result "⚠️ $role: NOT IDEMPOTENT"
  fi
  
  echo
done

# 2. Test playbook idempotence
print_section "TESTING FULL PLAYBOOK IDEMPOTENCE"
if ./setup.sh --idempotence -v --output="$TEST_DIR/full_idempotence.log"; then
  print_message "Full playbook is idempotent ✅"
  log_result "✅ FULL PLAYBOOK: IDEMPOTENT"
else
  print_warning "Full playbook is not fully idempotent ⚠️"
  log_result "⚠️ FULL PLAYBOOK: NOT IDEMPOTENT"
fi

# 3. OS compatibility test
print_section "TESTING OS COMPATIBILITY"
if ./setup.sh --test --os-compat-test -v --output="$TEST_DIR/os_compat.log"; then
  print_message "OS compatibility tests passed ✅"
  log_result "✅ OS COMPATIBILITY: PASSED"
else
  print_warning "OS compatibility tests failed ⚠️"
  log_result "⚠️ OS COMPATIBILITY: FAILED"
fi

# Print summary
print_section "TEST SUMMARY"
log_result "Test completed at: $(date)"
log_result "Passed roles: $PASSED_ROLES"
if [ -n "$FAILED_ROLES" ]; then
  log_result "Failed roles: $FAILED_ROLES"
fi
log_result "Full results available at: $TEST_DIR"

print_message "Testing complete! Results saved to $TEST_DIR"

# Exit with appropriate code
[ -z "$FAILED_ROLES" ]
