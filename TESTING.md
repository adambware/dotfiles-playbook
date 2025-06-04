# Testing Guide for dotfiles-playbook

This guide provides detailed information on how to test the macOS setup playbook to ensure everything is working correctly and is properly idempotent.

## Available Test Commands

The playbook includes several enhanced test and validation commands that can be run using the `setup.sh` script:

```bash
# Run validation checks on playbook syntax and structure
./setup.sh --validate

# Run tests to verify installation
./setup.sh --test

# Test if playbook is idempotent (runs playbook twice)
./setup.sh --idempotence

# Test a specific role
./setup.sh --test --role=ROLE_NAME

# Run tests with different verbosity levels
./setup.sh --test -v
./setup.sh --test -vv
./setup.sh --test -vvv

# Save test output to a file
./setup.sh --test --output=~/Desktop/test_results.txt

# Test with OS compatibility checks
./setup.sh --test --os-compat-test

# Get a detailed test summary
./setup.sh --test --summary
```

## Idempotence Testing

Idempotence means that running the playbook multiple times should not make changes after the first run. This is a key principle of proper automation.

### Advanced Idempotence Testing

The playbook includes an advanced idempotence test that:
1. Runs the playbook a first time
2. Runs it a second time and checks if any tasks changed
3. Reports specifically which tasks are not idempotent
4. Saves detailed results to a JSON file for analysis

```bash
# Test idempotence of the entire playbook
./setup.sh --idempotence

# Test idempotence of a specific role
./setup.sh --idempotence --role=adambware.private

# Test idempotence of specific tags
TEST_TAGS=homebrew,zsh ./setup.sh --idempotence

# Get detailed idempotence report
./setup.sh --idempotence --output=~/Desktop/idempotence_report.txt
```

### Fixing Non-Idempotent Tasks

When the idempotence test identifies non-idempotent tasks, you should:

1. Review the task implementation
2. Add proper state detection using:
   - `changed_when` directives
   - Pre-task checks to determine if changes are needed
   - File comparison for configuration files
   - Command output verification

The idempotence test provides specific suggestions for common task types.

## Role-Specific Testing

Each role has dedicated tests that verify its specific functionality.

### Core Infrastructure Testing

```bash
# Test the Homebrew installation
./setup.sh --test --role=adambware.homebrew-install

# Test ZSH configuration
./setup.sh --test --role=adambware.zsh
```

### Package Management Testing

```bash
# Test Homebrew packages
./setup.sh --test --role=adambware.homebrew-packages

# Test Homebrew casks (applications)
./setup.sh --test --role=adambware.homebrew-casks
```

### Development Environment Testing

```bash
# Test Node.js environment
./setup.sh --test --role=adambware.node

# Test Python environment
./setup.sh --test --role=adambware.python

# Test Ruby environment
./setup.sh --test --role=adambware.ruby
```

### System Configuration Testing

```bash
# Test macOS system settings
./setup.sh --test --role=adambware.osx

# Test macOS auto-update configuration
./setup.sh --test --role=adambware.auto-updates

# Test private configurations
./setup.sh --test --role=adambware.private
```

## Testing Across macOS Versions

To ensure compatibility across different macOS versions:

```bash
# Run OS compatibility tests
./setup.sh --test --os-compat-test

# Test specific role with OS compatibility checks
./setup.sh --test --role=adambware.osx --os-compat-test
```

## Architecture-Specific Testing

Tests automatically verify architecture-specific configurations:

```bash
# Test Intel-specific configurations
./setup.sh --test # (on Intel Mac)

# Test Apple Silicon-specific configurations
./setup.sh --test # (on Apple Silicon Mac)
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
   ./setup.sh --test -vvv
   ```

2. Check logs for specific error messages:
   ```bash
   grep -A 10 "failed:" /tmp/ansible.log
   ```

3. Isolate the failing task:
   ```bash
   # Run only a specific task using tags
   ./setup.sh --tags=TAG_NAME -vvv
   ```

4. Use check mode to preview changes:
   ```bash
   ./setup.sh --check --diff
   ```

5. Save detailed output for analysis:
   ```bash
   ./setup.sh --test --output=~/Desktop/test_debug.log
   ```

## Test Summary Reports

Get a comprehensive summary of test results:

```bash
# Generate a test summary
./setup.sh --test --summary

# Save test summary to a file
./setup.sh --test --summary --output=~/Desktop/test_summary.json
```

## Continuous Improvement

The testing framework is designed to evolve. Consider adding:

1. More role-specific tests
2. Integration tests between roles
3. Performance benchmarks
4. Additional validation checks

By regularly running tests and fixing issues, the playbook will become more robust and reliable.

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

1. More role-specific tests
2. Integration tests between roles
3. Performance benchmarks
4. Additional validation checks

By regularly running tests and fixing issues, the playbook will become more robust and reliable.
