# Testing Guide for dotfiles-playbook

This guide provides information on how to test the macOS setup playbook to ensure proper functionality and idempotence.

## Test Commands

```bash
# Run validation checks on playbook syntax and structure
./setup.sh --validate

# Run tests to verify installation
./setup.sh --test

# Test if playbook is idempotent (runs playbook twice)
./setup.sh --idempotence

# Test a specific role
./setup.sh --test --role=ROLE_NAME

# Run integration tests between roles
./setup.sh --integration-test

# Run macOS version-specific tests
./setup.sh --version-test

# Run all tests in sequence
./test_all.sh

# Run tests with different verbosity levels
./setup.sh --test -v

# Save test output to a file
./setup.sh --test --output=~/Desktop/test_results.txt

# Test with OS compatibility checks
./setup.sh --test --os-compat-test
```

## Idempotence Testing

Idempotence means that running the playbook multiple times should not make changes after the first run.

```bash
# Test idempotence of the entire playbook
./setup.sh --idempotence

# Test idempotence of a specific role
./setup.sh --idempotence --role=adambware.private

# Test idempotence of specific tags
TEST_TAGS=homebrew,zsh ./setup.sh --idempotence
```

### Fixing Non-Idempotent Tasks

When non-idempotent tasks are identified:

1. Review the task implementation
2. Add proper state detection using:
   - `changed_when` directives
   - Pre-task checks
   - File comparison for configuration files
   - Command output verification

## Role-Specific Testing

### Core Infrastructure

```bash
# Test the Homebrew installation
./setup.sh --test --role=adambware.homebrew-install

# Test ZSH configuration
./setup.sh --test --role=adambware.zsh
```

### Package Management

```bash
# Test Homebrew packages
./setup.sh --test --role=adambware.homebrew-packages

# Test Homebrew casks (applications)
./setup.sh --test --role=adambware.homebrew-casks
```

### Development Environment

```bash
# Test Node.js, Python, and Ruby environments
./setup.sh --test --role=adambware.node
./setup.sh --test --role=adambware.python
./setup.sh --test --role=adambware.ruby
```

### System Configuration

```bash
# Test macOS system settings
./setup.sh --test --role=adambware.osx

# Test macOS auto-update configuration
./setup.sh --test --role=adambware.auto-updates

# Test private configurations
./setup.sh --test --role=adambware.private
```

## Troubleshooting

If tests fail:

1. Run with increased verbosity: `./setup.sh --test -vvv`
2. Isolate the failing task: `./setup.sh --tags=TAG_NAME`
3. Use check mode: `./setup.sh --check --diff`
4. Save detailed output: `./setup.sh --test --output=~/Desktop/test_debug.log`

## Role-Specific Testing

Each role can be tested individually to verify its specific functionality.

### Private Role Testing

The private role has dedicated tests that verify SSH, Git, Homebrew, and configuration management:

```bash
# Run the private role tests
ansible-playbook roles/adambware.private/tests/test_private.yml
```

### Testing Other Roles

You can run specific roles using tags:

```bash
# Test only the node role
./setup.sh --tags=node --check

# Test python and ruby roles
./setup.sh --tags=python,ruby --check
```

## Testing New Features

When adding new features to the playbook:

1. Create dedicated test tasks in the relevant role
2. Run the playbook with `--check` to validate changes
3. Run the idempotence test to ensure multiple runs don't make changes
4. Add validation checks to the test playbook

## Troubleshooting

If tests fail:

1. Run with increased verbosity:
   ```bash
   ansible-playbook test.yml -vvv
   ```

2. Check logs for specific error messages:
   ```bash
   grep -A 10 "failed:" /tmp/ansible.log
   ```

3. Isolate the failing task:
   ```bash
   # Run only a specific task using tags
   ansible-playbook osx.yml --tags=TAG_NAME -vvv
   ```

4. Use check mode to preview changes:
   ```bash
   ansible-playbook osx.yml --check --diff
   ```

## Continuous Improvement

The testing framework is designed to evolve. Consider adding:

1. More version-specific tests
2. Integration tests between related roles
3. Performance measurements
4. Test coverage analysis

## Advanced Testing

The playbook now includes advanced testing capabilities:

### Comprehensive Testing

Run all tests in sequence with detailed logging:

```bash
./test_all.sh
```

This script will:
- Test each role individually
- Verify idempotence of each role
- Test the full playbook idempotence
- Run OS compatibility tests
- Generate a detailed test report

### Integration Testing

Test interactions between related roles:

```bash
./setup.sh --integration-test
```

This tests:
- Homebrew installation chain
- Development environment integration
- Shell environment setup
- macOS configuration interactions

### Version-Specific Testing

Test macOS version-specific features:

```bash
./setup.sh --version-test
```

This tests features specific to:
- macOS Monterey (12.x)
- macOS Ventura (13.x)
- macOS Sonoma (14.x)
- Future macOS versions
- Architecture-specific settings (Intel vs Apple Silicon)

## Test Output and Analysis

Test results are now saved in a structured format for easier analysis:

```bash
# Save test output to a file with timestamp
./setup.sh --test --output=~/Desktop/test_results_$(date +%Y%m%d_%H%M%S).log

# Using the comprehensive test script (automatically saves all results)
./test_all.sh
```

The comprehensive test script (`test_all.sh`) creates a timestamped directory with:
- Individual role test results
- Idempotence test results
- Summary log with pass/fail status for each role
- Architecture and OS version information

1. More role-specific tests
2. Integration tests between roles
3. Performance benchmarks
4. Additional validation checks

By regularly running tests and fixing issues, the playbook will become more robust and reliable.
