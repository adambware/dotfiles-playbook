#!/bin/bash
#
# Run the macOS setup playbook

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
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

print_info() {
  if [[ -n "$VERBOSE" ]]; then
    echo -e "${BLUE}INFO:${NC} $1"
  fi
}

print_debug() {
  if [[ "$VERBOSE" -ge 2 ]]; then
    echo -e "${PURPLE}DEBUG:${NC} $1"
  fi
}

print_status() {
  echo -e "${CYAN}STATUS:${NC} $1"
}

# Error handling function
handle_error() {
  print_error "An error occurred during execution!"
  print_error "Command: $BASH_COMMAND"
  print_error "Line: $1"
  print_error "Exit code: $2"
  
  print_message "For help, please check the TESTING.md file or run:"
  print_message "./setup.sh --help"
  
  exit $2
}

# Set up error handling
trap 'handle_error $LINENO $?' ERR

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  print_error "This script is designed to run on macOS only."
  exit 1
fi

# Check macOS version
MACOS_VERSION=$(sw_vers -productVersion)
MACOS_MAJOR=$(echo $MACOS_VERSION | cut -d. -f1)
MACOS_MINOR=$(echo $MACOS_VERSION | cut -d. -f2)

# Set macOS version flag
if [[ "$MACOS_MAJOR" -eq 12 ]]; then
  MACOS_NAME="Monterey"
elif [[ "$MACOS_MAJOR" -eq 13 ]]; then
  MACOS_NAME="Ventura"
elif [[ "$MACOS_MAJOR" -eq 14 ]]; then
  MACOS_NAME="Sonoma"
elif [[ "$MACOS_MAJOR" -gt 14 ]]; then
  MACOS_NAME="Future"
  print_warning "You are running a future version of macOS ($MACOS_VERSION)."
  print_warning "This playbook has not been fully tested on this version."
elif [[ "$MACOS_MAJOR" -lt 12 ]]; then
  MACOS_NAME="Legacy"
  print_warning "This playbook is designed for macOS Monterey (12.0) or later."
  print_warning "You are running macOS $MACOS_VERSION which may not be fully supported."
  read -p "Continue anyway? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_message "Exiting. Please upgrade to macOS Monterey or later."
    exit 0
  fi
fi

# Print macOS version information if verbose
if [[ -n "$VERBOSE" ]]; then
  print_info "Detected macOS $MACOS_NAME ($MACOS_VERSION)"
fi

# Architecture detection
if [[ "$(uname -m)" == "arm64" ]]; then
  ARCH="Apple Silicon"
  if [[ -n "$VERBOSE" ]]; then
    print_info "Detected Apple Silicon architecture"
  fi
else
  ARCH="Intel"
  if [[ -n "$VERBOSE" ]]; then
    print_info "Detected Intel architecture"
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
    if [[ "$ARCH" == "Apple Silicon" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
  
  print_message "Installing Ansible..."
  brew install ansible
  
  if ! command -v ansible >/dev/null 2>&1; then
    print_error "Failed to install Ansible. Please install it manually."
    exit 1
  fi
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
VERBOSE=0
SPECIFIC_ROLES=""
OS_COMPAT_TEST=""

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
    --integration-test)
      PLAYBOOK="integration_tests.yml"
      shift
      ;;
    --version-test)
      PLAYBOOK="macos_version_tests.yml"
      shift
      ;;
    --role=*)
      ROLE="${1#*=}"
      export TEST_ROLE="$ROLE"
      SPECIFIC_ROLES="$SPECIFIC_ROLES $ROLE"
      shift
      ;;
    --idempotence)
      PLAYBOOK="idempotence.yml"
      shift
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    -vv)
      VERBOSE=2
      shift
      ;;
    -vvv)
      VERBOSE=3
      shift
      ;;
    --output=*)
      OUTPUT_FILE="${1#*=}"
      shift
      ;;
    --os-compat-test)
      OS_COMPAT_TEST="true"
      shift
      ;;
    --summary)
      SUMMARY="true"
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
      echo "  -v, --verbose       Enable verbose output (level 1)"
      echo "  -vv                 Enable more verbose output (level 2)"
      echo "  -vvv                Enable maximum verbosity (level 3)"
      echo "  --output=FILE       Save output to specified file"
      echo "  --os-compat-test    Run OS compatibility tests"
      echo "  --summary           Show summary of results at the end"
      echo "  --help              Display this help message"
      exit 0
      ;;
    *)
      print_error "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Initialize output file if specified
if [[ -n "$OUTPUT_FILE" ]]; then
  echo "# macOS Setup Playbook Run - $(date)" > "$OUTPUT_FILE"
  echo "# macOS Version: $MACOS_VERSION ($MACOS_NAME)" >> "$OUTPUT_FILE"
  echo "# Architecture: $ARCH" >> "$OUTPUT_FILE"
  echo "# Command: $0 $*" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  print_message "Saving output to $OUTPUT_FILE"
fi

# Construct the command
CMD="ansible-playbook -K $PLAYBOOK"

# Add tags if specified
if [[ -n "$TAGS" && "$PLAYBOOK" == "osx.yml" ]]; then
  CMD="$CMD --tags $TAGS"
fi

# Add verbosity if specified
if [[ "$VERBOSE" -eq 1 ]]; then
  CMD="$CMD -v"
  print_message "Running with verbose output (level 1)..."
elif [[ "$VERBOSE" -eq 2 ]]; then
  CMD="$CMD -vv"
  print_message "Running with more verbose output (level 2)..."
elif [[ "$VERBOSE" -eq 3 ]]; then
  CMD="$CMD -vvv"
  print_message "Running with maximum verbosity (level 3)..."
fi

# Add OS compatibility testing flags if requested
if [[ "$OS_COMPAT_TEST" == "true" ]]; then
  print_message "Running OS compatibility tests for macOS $MACOS_NAME..."
  export MACOS_COMPAT_TEST="true"
  export MACOS_VERSION="$MACOS_VERSION"
  export MACOS_NAME="$MACOS_NAME"
  export ARCH="$ARCH"
fi

# Add check flag if specified
if [[ -n "$CHECK" ]]; then
  CMD="$CMD $CHECK"
  print_message "Running in check mode (NO changes will be made)..."
  print_message "This is a dry run only - Homebrew will not update and no packages will be installed."
fi

print_message "Running: $CMD"

# Execute the command and capture output if needed
if [[ -n "$OUTPUT_FILE" ]]; then
  print_status "Executing playbook (this may take a while)..."
  eval "$CMD" | tee -a "$OUTPUT_FILE"
  EXIT_CODE=${PIPESTATUS[0]}
  if [[ $EXIT_CODE -ne 0 ]]; then
    print_error "Playbook execution failed with exit code $EXIT_CODE"
    exit $EXIT_CODE
  fi
else
  print_status "Executing playbook (this may take a while)..."
  eval "$CMD"
fi

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
  print_message "Run without --check to apply these changes."
fi

# Final message if output was saved to file
if [[ -n "$OUTPUT_FILE" ]]; then
  print_message "Output has been saved to $OUTPUT_FILE"
fi
