# Testing Guide for dotfiles-playbook

This guide provides detailed information on how to test the macOS setup playbook to ensure everything is working correctly and is properly idempotent.

## Available Test Commands

The playbook includes several test and validation commands that can be run using the `setup.sh` script:

```bash
# Run validation checks on playbook syntax and structure
./setup.sh --validate

# Run tests to verify installation
./setup.sh --test

# Test if playbook is idempotent (runs playbook twice)
./setup.sh --idempotence

# Test a specific role
./setup.sh --test --tags=ROLE_NAME
```

## Idempotence Testing

Idempotence means that running the playbook multiple times should not make changes after the first run. This is a key principle of proper automation.

### Advanced Idempotence Testing

The playbook includes an advanced idempotence test that:
1. Runs the playbook a first time
2. Runs it a second time and checks if any tasks changed
3. Reports specifically which tasks are not idempotent

```bash
# Test idempotence of the entire playbook
./setup.sh --idempotence

# Test idempotence of a specific role
TEST_ROLE=adambware.private ./setup.sh --idempotence

# Test idempotence of specific tags
TEST_TAGS=homebrew,zsh ./setup.sh --idempotence
```

### Fixing Non-Idempotent Tasks

When the idempotence test identifies non-idempotent tasks, you should:

1. Review the task implementation
2. Add proper state detection using:
   - `changed_when` directives
   - Pre-task checks to determine if changes are needed
   - File comparison for configuration files
   - Command output verification

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
