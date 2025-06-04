#!/bin/bash
#
# Run the macOS setup playbook

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  print_error "This script is designed to run on macOS only."
  exit 1
fi

# Check macOS version
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo $MACOS_VERSION | cut -d. -f1)
MACOS_MINOR=$(echo $MACOS_VERSION | cut -d. -f2)

if [[ "$MACOS_MAJOR" -lt 12 ]]; then
  print_warning "This playbook is designed for macOS Monterey (12.0) or later."
  print_warning "You are running macOS $MACOS_VERSION which may not be fully supported."
  read -p "Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_message "Exiting. Please upgrade to macOS Monterey or later."
    exit 0
  fi
fi

# Check for Ansible
if ! command -v ansible >/dev/null 2>&1; then
  print_warning "Ansible not found. Attempting to install..."
  
  # Check for Homebrew
  if ! command -v brew >/dev/null 2>&1; then
    print_message "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ "$(uname -m)" == "arm64" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
  
  print_message "Installing Ansible..."
  brew install ansible
fi

# Check for ansible-lint
if ! command -v ansible-lint >/dev/null 2>&1; then
  print_message "Installing ansible-lint for validation..."
  brew install ansible-lint
fi

# Print welcome message
print_message "Starting macOS setup playbook..."

# Set default tags to empty (run everything)
TAGS=""
PLAYBOOK="osx.yml"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tags=*)
      TAGS="${1#*=}"
      shift
      ;;
    --check)
      CHECK="--check"
      shift
      ;;
    --validate)
      PLAYBOOK="validate.yml"
      shift
      ;;
    --test)
      PLAYBOOK="test.yml"
      shift
      ;;
    --role=*)
      ROLE="${1#*=}"
      export TEST_ROLE="$ROLE"
      shift
      ;;
    --idempotence)
      PLAYBOOK="idempotence.yml"
      shift
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo ""
      echo "Options:"
      echo "  --tags=TAG1,TAG2    Run only specific roles by tag"
      echo "  --check             Run in check mode (dry run, no changes)"
      echo "  --validate          Run validation checks on playbook"
      echo "  --test              Run tests to verify installation"
      echo "  --role=ROLE_NAME    Run tests for a specific role"
      echo "  --idempotence       Test if playbook is idempotent"
      echo "  --help              Display this help message"
      exit 0
      ;;
    *)
      print_error "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Construct the command
CMD="ansible-playbook -K $PLAYBOOK"

# Add tags if specified
if [[ -n "$TAGS" && "$PLAYBOOK" == "osx.yml" ]]; then
  CMD="$CMD --tags $TAGS"
fi

# Add check flag if specified
if [[ -n "$CHECK" ]]; then
  CMD="$CMD $CHECK"
  print_message "Running in check mode (NO changes will be made)..."
  print_message "This is a dry run only - Homebrew will not update and no packages will be installed."
fi

print_message "Running: $CMD"
eval "$CMD"

# Print completion message
if [[ -z "$CHECK" ]]; then
  if [[ "$PLAYBOOK" == "osx.yml" ]]; then
    print_message "macOS setup complete! 🎉"
    print_message "You may want to restart your Mac to ensure all changes take effect."
  elif [[ "$PLAYBOOK" == "validate.yml" ]]; then
    print_message "Validation completed!"
  elif [[ "$PLAYBOOK" == "test.yml" ]]; then
    print_message "Tests completed!"
  elif [[ "$PLAYBOOK" == "idempotence.yml" ]]; then
    print_message "Idempotence test completed!"
    print_message "Review the output above to see if any tasks would have changed."
  fi
else
  print_message "Check completed. No changes were made."
  print_message "The output above shows what would have changed if this was a real run."
  print_message "Run without --check to apply these changes."
fi
