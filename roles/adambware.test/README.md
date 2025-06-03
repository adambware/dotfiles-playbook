# Role: adambware.test

A comprehensive testing role that validates the successful installation and configuration of your macOS environment.

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+
- All other roles must be applied first

## Role Variables

The role uses variables from the main playbook to check that everything was properly installed.

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.test
```

## Notes

- This role performs validation tests only
- It checks that core components are installed and working
- Run this role after all other roles to verify your setup
- No changes are made to your system by this role

## Tests Performed

- Verifies Homebrew installation
- Verifies ZSH installation and configuration
- Verifies Node.js and npm installation
- Verifies Ruby installation
- Verifies Python installation
- Checks for critical Homebrew packages
- Checks for important GUI applications
- Verifies architecture-specific configurations (Intel vs Apple Silicon)
- Validates path configurations
- Verifies application installations
- Checks critical configuration files
- Displays detailed system diagnostics
- Provides idempotence testing guidance

## Idempotence Testing

This role is fully idempotent and uses proper `changed_when` directives for all commands.
It provides information about idempotence testing and encourages proper idempotence
in all roles.

You can run the dedicated idempotence test with:

```bash
./setup.sh --idempotence
```
